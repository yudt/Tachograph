//
//  AssetWriterCoordinator.swift
//  Tachograph
//
//  Created by Ethan on 16/5/21.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation

// internal state machine

private enum WriterStatus : Int{
    case Idle // 闲置
    case PreparingToRecord  // 准备记录
    case Recording          // 记录中
    case FinishingRecordingPart1  // 等待追加缓存
    case FinishingRecordingPart2  // 完成写入
    case Finished // 终端状态
    case Failed   // 终端状态
}



class AssetWriterCoordinator: NSObject {
    weak var delegate : AssetWriterCoordinatorDelegate?
    var url : NSURL!
    private var status : WriterStatus = .Idle
    private var writingQueue : dispatch_queue_t!
    private var delegateCallbackQueue : dispatch_queue_t!
    private var assetWriter : AVAssetWriter!
    private var haveStartedSession : Bool = false
    
    // audio
    private var audioTrackSourceFormatDescription : CMFormatDescriptionRef!
    private var audioTrackSettings : [String : AnyObject] = [:]
    private var audioInput : AVAssetWriterInput!
    // video
    private var videoTrackSourceFormatDescription : CMFormatDescriptionRef!
    private var videoTrackTransform : CGAffineTransform!
    private var videoTrackSettings : [String : AnyObject] = [:]
    private var videoInput : AVAssetWriterInput?
    
    
    override init() {
        super.init()
        writingQueue = dispatch_queue_create("org.xmyy.assetwriter.writing", DISPATCH_QUEUE_SERIAL)
        videoTrackTransform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: External methods
extension AssetWriterCoordinator{
    
    func setURL(url : NSURL){
        self.url = url
    }
    
    func setDelegate<T : AssetWriterCoordinatorDelegate>(delegate : T , callbackQueue : dispatch_queue_t){
        
        objc_sync_enter(self)
        
        self.delegate = delegate
        
        self.delegateCallbackQueue = callbackQueue
        
        objc_sync_exit(self)
    }
    
    func addVideoTrackWithSourceFormatDescription(formatDescription : CMFormatDescriptionRef,videoSettings : NSDictionary){
        
        objc_sync_enter(self)
        if status != .Idle {
            MSGLog(Message: "非闲置状态")
            return
        }
        videoTrackSourceFormatDescription = formatDescription
        videoTrackSettings = videoSettings as! [String : AnyObject]
        
        objc_sync_exit(self)

    }
    
    func addAudioTrackWithSourceFormatDescription(formatDescription : CMFormatDescriptionRef,audioSettings : NSDictionary){
        
        objc_sync_enter(self)
        
        if status != .Idle {
            MSGLog(Message: "非闲置状态")
            return
        }
        
        audioTrackSourceFormatDescription = formatDescription
        audioTrackSettings = audioSettings as! [String : AnyObject]
        
        objc_sync_exit(self)
        
    }
    
    func appendVideoSampleBuffer(sampleBuffer : CMSampleBufferRef){
        appendSampleBuffer(sampleBuffer, mediaType: AVMediaTypeVideo)
    }
    
    func appendAudioSampleBuffer(sampleBuffer : CMSampleBufferRef){
        appendSampleBuffer(sampleBuffer, mediaType: AVMediaTypeAudio)

    }
    
    func prepareToRecord(){
        
        objc_sync_enter(self)
        
        if status != .Idle {
            MSGLog(Message: "非闲置状态")
            return
        }
        
        var error : NSError? = cannotSetupInputError()

        transitionToStatus(.PreparingToRecord, error: error!)
        
        objc_sync_exit(self)

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {

            error = nil

            // AVAssetWriter will not write over an existing file.
            do{
                try NSFileManager.defaultManager().removeItemAtURL(self.url)
                do{
                    try self.assetWriter = AVAssetWriter.init(URL: self.url, fileType: AVFileTypeQuickTimeMovie)
                    
                    self.setupAssetWriterVideoInputWithSourceFormatDescription(self.videoTrackSourceFormatDescription, transform: self.videoTrackTransform, videoSettings: &self.videoTrackSettings, errorOut: &error!)
                    self.setupAssetWriterAudioInputWithSourceFormatDescription(self.audioTrackSourceFormatDescription, audioSettings: &self.audioTrackSettings , errorOut: &error!)
                    let  success : Bool = self.assetWriter.startWriting()
                    if !success{
                        error  = self.assetWriter.error
                    }
                }catch{
                    
                }
            }catch{
                
            }
            
            objc_sync_enter(self)
            if error != nil{
                self.transitionToStatus(.Failed, error: error!)
            }else{
                self.transitionToStatus(.Recording, error: nil)
            }
            objc_sync_exit(self)
            
        }
    }
    
    func finishRecording(){
        
        objc_sync_enter(self)
        var shouldFinishRecording : Bool = false
        switch  status {
        case .Failed:
        // From the client's perspective the movie recorder can asynchronously transition to an error state as the result of an append.
        // Because of this we are lenient when finishRecording is called and we are in an error state.
            MSGLog(Message: "Recording has failed, nothing to do!")
            
        case .Recording:
            shouldFinishRecording = true

        default:
            break
        }
        
        if shouldFinishRecording {
            transitionToStatus(.FinishingRecordingPart1, error: nil)
        }else{
            return
        }
        
        objc_sync_exit(self)
        
        
        dispatch_async(writingQueue) { 
            
            objc_sync_enter(self)
            // We may have transitioned to an error state as we appended inflight buffers. In that case there is nothing to do now.
            if self.status != .FinishingRecordingPart1{
                return
            }
            
            // It is not safe to call -[AVAssetWriter finishWriting*] concurrently with -[AVAssetWriterInput appendSampleBuffer:]
            // We transition to MovieRecorderStatusFinishingRecordingPart2 while on _writingQueue, which guarantees that no more buffers will be appended.
            
            self.transitionToStatus(.FinishingRecordingPart2, error: nil)
            
            
            objc_sync_exit(self)
            
            self.assetWriter.finishWritingWithCompletionHandler({ 
                objc_sync_enter(self)
                let error : NSError? = self.assetWriter.error
                if let err = error{
                    self.transitionToStatus(.Failed, error:err)
                }else{
                    self.transitionToStatus(.Finished, error: nil)
                }
                
                objc_sync_exit(self)
            })
        }
    }
    
}

// MARK: Private methods
private extension AssetWriterCoordinator{
    func setupAssetWriterAudioInputWithSourceFormatDescription(audioFormatDescription : CMFormatDescriptionRef ,inout audioSettings : [String : AnyObject] , inout errorOut : NSError) -> Bool {
        audioSettings = [AVFormatIDKey : NSNumber.init(unsignedInt: kAudioFormatMPEG4AAC)]
        
        if assetWriter.canApplyOutputSettings( audioSettings , forMediaType:AVMediaTypeAudio) {
            audioInput = AVAssetWriterInput(mediaType: AVMediaTypeAudio , outputSettings: audioSettings  ,sourceFormatHint: audioFormatDescription)
            audioInput.expectsMediaDataInRealTime = true
            
            
            if assetWriter.canAddInput(audioInput){
                assetWriter.addInput(audioInput)
                return true
            }else{
                errorOut = cannotSetupInputError()
                return false
            }
        }else{
            errorOut = cannotSetupInputError()
            return false
        }
    }
    
    func setupAssetWriterVideoInputWithSourceFormatDescription(videoFormatDescription : CMFormatDescriptionRef , transform : CGAffineTransform ,inout videoSettings : [String : AnyObject],inout errorOut : NSError ) -> Bool {
        videoSettings = fallbackVideoSettingsForSourceFormatDescription(videoFormatDescription) as! [String : AnyObject]
        
        if assetWriter.canApplyOutputSettings(videoSettings, forMediaType: AVMediaTypeVideo) {
            videoInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo , outputSettings:videoSettings , sourceFormatHint:videoFormatDescription)
            
            videoInput?.expectsMediaDataInRealTime = true
            videoInput?.transform = transform
            
            if assetWriter.canAddInput(videoInput!){
                assetWriter.addInput(videoInput!)
                return true
            }else{
                errorOut = cannotSetupInputError()
                return false
            }
        }else{
            errorOut = cannotSetupInputError()
            return false
        }
    }
    
    func fallbackVideoSettingsForSourceFormatDescription(videoFormatDescription : CMFormatDescriptionRef) -> NSDictionary{
        var bitsPerPixel : Float!
        let dimensions : CMVideoDimensions = CMVideoFormatDescriptionGetDimensions(videoFormatDescription)
        let numPixels : Int = Int( dimensions.width * dimensions.height)
        var bitsPerSecond : Int!
        
        // Assume that lower-than-SD resolutions are intended for streaming, and use a lower bitrate
        if numPixels < (640 * 480) {
            bitsPerPixel = 4.05 // This bitrate approximately matches the quality produced by AVCaptureSessionPresetMedium or Low.
        }else{
            bitsPerPixel = 10.1  // This bitrate approximately matches the quality produced by AVCaptureSessionPresetHigh.
        }
        
        bitsPerSecond = numPixels * Int(bitsPerPixel)
        
        let compressionProperties : NSDictionary = [AVVideoAverageBitRateKey:NSNumber.init(long: bitsPerSecond),AVVideoExpectedSourceFrameRateKey:NSNumber.init(long: 30),AVVideoMaxKeyFrameIntervalKey:NSNumber.init(long: 30)]
        
        return [AVVideoCodecKey:AVVideoCodecH264 , AVVideoWidthKey : NSNumber.init(int: dimensions.width) ,AVVideoHeightKey:NSNumber.init(int: dimensions.height),AVVideoCompressionPropertiesKey:compressionProperties]

    }
    
    func appendSampleBuffer(sampleBuffer : CMSampleBufferRef, mediaType : NSString){
        
        objc_sync_enter(self)

        if status == .Idle || status == .PreparingToRecord {
            MSGLog(Message: "Not ready to record yet")
            return
        }
        
        
        objc_sync_exit(self)
        
        dispatch_async(writingQueue) {
            
            objc_sync_enter(self)
            
            // From the client's perspective the movie recorder can asynchronously transition to an error state as the result of an append.
            // Because of this we are lenient when samples are appended and we are no longer recording.
            // Instead of throwing an exception we just release the sample buffers and return.
            
            if self.status == .FinishingRecordingPart2  || self.status == .Finished || self.status == .Failed{
                MSGLog(Message: "录制完成，不能继续追加")
                return
            }
            
            objc_sync_exit(self)
            
            if !self.haveStartedSession && mediaType == AVMediaTypeVideo{
                self.assetWriter.startSessionAtSourceTime(CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                self.haveStartedSession = true
            }
            
            let input : AVAssetWriterInput!
            if mediaType == AVMediaTypeVideo{
                input = self.videoInput
            }else{
                input = self.audioInput
            }
            
            if input.readyForMoreMediaData{
                
                let succec : Bool = input.appendSampleBuffer(sampleBuffer)
                
                if !succec{
                    
                    let error : NSError? = self.assetWriter.error
                    
                    if let newError = error{
                        objc_sync_enter(self)
                        self.transitionToStatus(.Failed, error: newError)
                        objc_sync_exit(self)
                    }
                    
                }else{
                    MSGLog(Message: "\(mediaType) input not ready for more media data, dropping buffer")
                }
            }
            
        }
    }
    
    func transitionToStatus(newStatus : WriterStatus , error : NSError?){
        
        var shouldNotifyDelegate : Bool = false
        if  newStatus != status {
            
            // terminal states
            if newStatus == .Finished || newStatus == .Failed {
                shouldNotifyDelegate = true
                // make sure there are no more sample buffers in flight before we tear down the asset writer and inputs
                dispatch_async(writingQueue, { 
                    
                    self.assetWriter = nil
                    self.audioInput = nil
                    self.videoInput = nil
                    if newStatus == .Failed{
                        do{
                           try  NSFileManager.defaultManager().removeItemAtURL(self.url)
                        }catch {
                            
                        }
                    }else if newStatus == .Recording {
                       shouldNotifyDelegate = true
                    }
                    self.status = newStatus
                })
            }
            
            
            if shouldNotifyDelegate && self.delegate != nil {
                dispatch_async(delegateCallbackQueue, {
                    switch newStatus{
                        
                    case .Recording:
                        self.delegate?.writerCoordinatorDidFinishPreparing(self)
                    case .Finished:
                        self.delegate?.writerCoordinatorDidFinishRecording(self)
                    case .Failed:
                        self.delegate?.writerCoordinatorDidFail(self, error: error!)
                    default:
                        break
                    }
                })
            }
        }
    }
    
    func cannotSetupInputError() -> NSError{
        
        let localizedDescription = "Recording cannot be started"
        let localizedFailureReason = "Cannot setup asset writer input."
        
        let errorDict = [NSLocalizedDescriptionKey : localizedDescription,NSLocalizedFailureReasonErrorKey : localizedFailureReason]
        return NSError(domain: "org.xmyy" , code: 0 ,userInfo:  errorDict)
    }
}

@objc protocol AssetWriterCoordinatorDelegate : NSObjectProtocol{
    
    func writerCoordinatorDidFinishPreparing(coordinator : AssetWriterCoordinator)
    func writerCoordinatorDidFinishRecording(coordinator : AssetWriterCoordinator)
    func writerCoordinatorDidFail(coordinator : AssetWriterCoordinator , error : NSError)
    
}


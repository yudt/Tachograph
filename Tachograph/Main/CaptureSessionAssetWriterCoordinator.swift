//
//  CaptureSessionAssetWriterCoordinator.swift
//  Tachograph
//
//  Created by Ethan on 16/5/21.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation


enum RecordingStatus : Int {
    case Idle = 0
    case StartingRecording
    case Recording
    case StoppingRecording
}



class CaptureSessionAssetWriterCoordinator: CaptureSessionCoordinator {

    var videoDataOutputQueue : dispatch_queue_t!
    var audioDataOutputQueue : dispatch_queue_t!
    
    var videoDataOutput : AVCaptureVideoDataOutput!
    var audioDataOutput : AVCaptureAudioDataOutput!
    
    var videoConnection : AVCaptureConnection!
    var audioConnection : AVCaptureConnection!
    
    var videoCompressionSettings : [String : AnyObject]!
    var audioCompressionSettings : [String : AnyObject]!
    
    var outputVideoFormatDescription : CMFormatDescriptionRef!
    var outputAudioFormatDescription : CMFormatDescriptionRef!
    
    var assetWriter : AVAssetWriter!
    
    var recordingStatus : RecordingStatus = .Idle
    
    var recordingURL : NSURL!
    
    var assetWriterCoordinator : AssetWriterCoordinator!
    
    
    override init() {
        super.init()
        videoDataOutputQueue = dispatch_queue_create("org.xmyy.capturesession.videodata", DISPATCH_QUEUE_SERIAL)
        dispatch_set_target_queue(videoDataOutputQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
        
        audioDataOutputQueue = dispatch_queue_create("org.xmyy.capturesession.audiodata", DISPATCH_QUEUE_SERIAL)
        
        addDataOutputsToCaptureSession(captureSession)
    }
    
    override func startRecording() {
        objc_sync_enter(self)
        if recordingStatus != .Idle {
            MSGLog(Message: "Already recording")
            return
        }
        
        var error : NSError?
        
        transitionToRecordingStatus( .StartingRecording, error: &error)
        
        objc_sync_exit(self)
        
        recordingURL = FileManager.createFileUrl()
        assetWriterCoordinator = AssetWriterCoordinator()
        assetWriterCoordinator.url = recordingURL
        if outputAudioFormatDescription != nil {
            assetWriterCoordinator.addAudioTrackWithSourceFormatDescription(outputAudioFormatDescription, audioSettings:audioCompressionSettings as NSDictionary)
            assetWriterCoordinator.addVideoTrackWithSourceFormatDescription(outputVideoFormatDescription, videoSettings: videoCompressionSettings as NSDictionary)
            
            let callbackQueue = dispatch_queue_create("org.xmyy.capturesession.writercallback", DISPATCH_QUEUE_SERIAL)
            assetWriterCoordinator.setDelegate(self, callbackQueue: callbackQueue)
            assetWriterCoordinator.prepareToRecord() // asynchronous, will call us back with recorderDidFinishPreparing: or recorder:didFailWithError: when done
            
        }
        
    }
    
    override func stopRecording() {
        objc_sync_enter(self)
        if recordingStatus != .Recording {
            MSGLog(Message: "nothing to do!!")
            return
        }
        var error : NSError?
        transitionToRecordingStatus(.StoppingRecording, error: &error)
        objc_sync_exit(self)
        
        assetWriterCoordinator.finishRecording()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: private methods
private extension CaptureSessionAssetWriterCoordinator{
    func transitionToRecordingStatus(newStatus : RecordingStatus ,inout error : NSError?){
        let oldStatus : RecordingStatus = recordingStatus
        recordingStatus = newStatus
        
        if newStatus != oldStatus {
            if  let err = error {
                if newStatus == .Idle {
                    dispatch_async(self.callBackQueue, { 
                        
                        self.delegate?.coordinatorDidFinishRecording(self, outputFileURL: self.recordingURL, err)
                        
                    })
                }else{
                    error = nil
                    if  oldStatus == .StartingRecording && newStatus == .Recording {
                        dispatch_async(self.callBackQueue, { 
                            self.delegate?.coordinatorDidBeginRecording(self)
                        })
                    }else if oldStatus == .StoppingRecording && newStatus == .Idle{
                        dispatch_async(self.callBackQueue, { 
                            self.delegate?.coordinatorDidFinishRecording(self, outputFileURL: self.recordingURL, err)
                        })
                    }
                }
            }
        }
    }
}
// MARK: AssetWriterCoordinatorDelegate methods
extension CaptureSessionAssetWriterCoordinator : AssetWriterCoordinatorDelegate{

    func writerCoordinatorDidFinishPreparing(coordinator : AssetWriterCoordinator){
        
        objc_sync_enter(self)
        
        if recordingStatus !=  .StartingRecording{
            MSGLog(Message: "Expected to be in StartingRecording state")
            return
        }
        var error : NSError?
        
        transitionToRecordingStatus(.Recording, error: &error)
        
        objc_sync_exit(self)
        
    }
    
    func writerCoordinatorDidFinishRecording(coordinator : AssetWriterCoordinator){
        
        objc_sync_enter(self)

        if recordingStatus != .StoppingRecording {
            MSGLog(Message: "Expected to be in StoppingRecording state")
            return
        }
        
        // No state transition, we are still in the process of stopping.
        // We will be stopped once we save to the assets library.
        
        objc_sync_exit(self)
        
        assetWriterCoordinator = nil
        
        objc_sync_enter(self)
        
        var error : NSError?

        transitionToRecordingStatus(.Idle, error: &error)
        
        objc_sync_exit(self)
    }
    
    func writerCoordinatorDidFail(coordinator : AssetWriterCoordinator , error : NSError){
        objc_sync_enter(self)
        assetWriterCoordinator = nil
        var error : NSError?

        transitionToRecordingStatus(.Idle, error: &error)
        
        objc_sync_exit(self)
    }
    
}

extension CaptureSessionAssetWriterCoordinator : AVCaptureVideoDataOutputSampleBufferDelegate , AVCaptureAudioDataOutputSampleBufferDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let formatDescription : CMFormatDescriptionRef = CMSampleBufferGetFormatDescription(sampleBuffer)!
        
        if connection === videoConnection {
            if outputVideoFormatDescription == nil {
                
                // Don't render the first sample buffer.
                // This gives us one frame interval (33ms at 30fps) for setupVideoPipelineWithInputFormatDescription: to complete.
                // Ideally this would be done asynchronously to ensure frames don't back up on slower devices.
                
                //TODO: outputVideoFormatDescription should be updated whenever video configuration is changed (frame rate, etc.)
                //Currently we don't use the outputVideoFormatDescription in IDAssetWriterRecoredSession
                setupVideoPipelineWithInputFormatDescription(formatDescription)
            }else{
                self.outputVideoFormatDescription = formatDescription
                
                objc_sync_enter(self)
                
                if recordingStatus == .Recording {
                    assetWriterCoordinator.appendVideoSampleBuffer(sampleBuffer)
                }
                
                objc_sync_exit(self)
                
            }
        }else if connection === audioConnection{
            self.outputAudioFormatDescription = formatDescription
            
            objc_sync_enter(self)
            
            if recordingStatus == .Recording {
                assetWriterCoordinator.appendAudioSampleBuffer(sampleBuffer)
            }
            
            objc_sync_exit(self)
        }
    }
}

// private methods
private extension CaptureSessionAssetWriterCoordinator{
    
    func addDataOutputsToCaptureSession(captureSession : AVCaptureSession){
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = nil
        videoDataOutput.alwaysDiscardsLateVideoFrames = false
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        addOutput(videoDataOutput, captureSession: captureSession)
        videoConnection = videoDataOutput.connectionWithMediaType(AVMediaTypeVideo)
        
        
        audioDataOutput = AVCaptureAudioDataOutput()
        audioDataOutput.setSampleBufferDelegate(self, queue: audioDataOutputQueue)
        addOutput(audioDataOutput, captureSession: captureSession)
        audioConnection = audioDataOutput.connectionWithMediaType(AVMediaTypeAudio)
        
        
        let videoDict = videoDataOutput.recommendedVideoSettingsForAssetWriterWithOutputFileType(AVFileTypeQuickTimeMovie)
        let videoKey  = videoDict.keys.first as! String
        videoCompressionSettings = [videoKey : videoDict[videoKey]!]
        
        
        let audioDict = audioDataOutput.recommendedAudioSettingsForAssetWriterWithOutputFileType(AVFileTypeQuickTimeMovie)
        let audioKey  = audioDict.keys.first as! String
        audioCompressionSettings = [audioKey : audioDict[audioKey]!]
    }
    
    func setupVideoPipelineWithInputFormatDescription(inputFormatDescription : CMFormatDescriptionRef){
        self.outputVideoFormatDescription = inputFormatDescription
    }
    
    
    func teardownVideoPipeline(){
        self.outputVideoFormatDescription = nil
    }
    
}






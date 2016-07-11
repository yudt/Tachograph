//
//  CaptureManager.swift
//  Tachograph
//
//  Created by Ethan on 16/5/5.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary


enum PipelineMode : Int {
    case MovieFileOutput
    case AssetWriter
}

class CaptureManager: NSObject {


    var captureSessionCoordinator : CaptureSessionCoordinator!
    var recording : Bool = false
    var dismissing : Bool = false
    
    private override init() {
        super.init()
        
        setupWithPipelineMode(.MovieFileOutput)

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private static let sharedCaptureManager : CaptureManager = {
        
        return CaptureManager()
        
    }()
    
    class func sharedInstance() -> CaptureManager{
        
        return sharedCaptureManager
        
    }
    
    
    
}

// 录像相关接口
extension CaptureManager{
    
    // 录像中。。。
    func starRecording(){
        if recording {
            captureSessionCoordinator.stopRecording()
        }else{
            captureSessionCoordinator.startRecording()
        }
    }
    
    // 录像停止
    func stopRecording(){
        captureSessionCoordinator.stopRecording()
    }
    
    // 切换摄像头
    func swapFrontAndBackCameras(){
        captureSessionCoordinator.swapFrontAndBackCameras()
    }
    
    // preLayer
    func prelayer() -> AVCaptureVideoPreviewLayer? {
        if captureSessionCoordinator == nil {
            return nil
        }else{
            return captureSessionCoordinator.previewLayer
        }
    }
    
    
    // setMode
    func setupWithPipelineMode(pipelineMode : PipelineMode){
        
        checkPermissions()
        
        switch pipelineMode {
            
        case .MovieFileOutput:
            captureSessionCoordinator  = CaptureSessionMovieFileOutputCoordinator()
            break
            
        case .AssetWriter:
            captureSessionCoordinator = CaptureSessionAssetWriterCoordinator()
            break
            
        }
        
        captureSessionCoordinator.setDelegate(self, callBackQueue: dispatch_get_main_queue())
        captureSessionCoordinator.startRunning()

    }
}


// DevicesPermission  (Microphone , Camera)
extension CaptureManager : UIAlertViewDelegate{
    
    func checkPermissions(){
        
        checkCameraAuthorizationStatus { (granted) in
            if !granted {
                MSGLog(Message: "we don't have permission to use the camera")
            }
        }
        
        checkMicrophonePermission { (granted) in
            if !granted {
                MSGLog(Message: "we don't have permission to use the microphone")
            }
        }
    }
    
    // Microphone
    private func checkMicrophonePermission(block : (granted : Bool) -> ()){
        
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeAudio) { (granted) in
            if !granted {
                //Not granted access to mediaType
                dispatch_async(dispatch_get_main_queue(), { 
                    let alert = UIAlertView.init(title: "麦克风禁用", message: "应用不允许使用麦克风，请到设置中页面开启麦克风功能", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "去设置")
                    alert.delegate = self
                    alert.show()
                })
            }
            block(granted: granted)
        }
    }
    
    // Camera
    private func checkCameraAuthorizationStatus(block : (granted : Bool) -> ()){
        
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (granted) in
            if !granted {
                //Not granted access to mediaType
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertView.init(title: "摄像头禁用", message: "应用不允许使用相机，请到设置中页面开启摄像头功能", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "去设置")
                    alert.delegate = self
                    alert.show()
                })
            }
            block(granted: granted)
        }
    }
    
    // MARK: UIAlertViewDelegate methods
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            UIApplication.sharedApplication().openURL(NSURL.fileURLWithPath(UIApplicationOpenSettingsURLString))
        }
    }
}

// MARK: CaptureSessionCoordinatorDelegate
extension CaptureManager: CaptureSessionCoordinatorDelegate {
    
    func coordinatorDidBeginRecording(coordinator : CaptureSessionCoordinator){
        // 屏幕常亮
        UIApplication.sharedApplication().idleTimerDisabled = true

    }
    
    func coordinatorDidFinishRecording(coordinator : CaptureSessionCoordinator , outputFileURL : NSURL ,_ error : NSError?){
        
        let library : ALAssetsLibrary =  ALAssetsLibrary()
        // 应用已经满了的提示
        
        // 关闭屏幕常亮
        UIApplication.sharedApplication().idleTimerDisabled = false
        
        library.writeVideoAtPathToSavedPhotosAlbum(outputFileURL) { (assetURL,error) in
            
            
            
        }
        
    }
    
}

// MARK: tools
extension CaptureManager{
    
    class func getVideoImage(pathUrl : String) -> UIImage?{
        
        let asset : AVURLAsset = AVURLAsset.init(URL: NSURL.fileURLWithPath(pathUrl ), options: nil)
        
        let generator : AVAssetImageGenerator = AVAssetImageGenerator.init(asset: asset)
        
        generator.appliesPreferredTrackTransform = true
        
        let time : CMTime = CMTimeMakeWithSeconds(0, 600) //  参数( 截取的秒数， 视频每秒多少帧)
        
        
        let actualTime : UnsafeMutablePointer<CMTime>  = nil
        
        do{
            let image : CGImage = try generator.copyCGImageAtTime(time, actualTime: actualTime)
            
            return UIImage.init(CGImage: image)
            
        }catch{
            
        }
        
        return nil
    }
    
}








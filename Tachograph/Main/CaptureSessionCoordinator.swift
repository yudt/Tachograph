//
//  CaptureSessionCoordinator.swift
//  Tachograph
//
//  Created by Ethan on 16/5/20.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation


@objc protocol CaptureSessionCoordinatorDelegate : NSObjectProtocol{
    
    func coordinatorDidBeginRecording(coordinator : CaptureSessionCoordinator)
    func coordinatorDidFinishRecording(coordinator : CaptureSessionCoordinator , outputFileURL : NSURL ,_ error : NSError?)
    
}

class CaptureSessionCoordinator: NSObject {
    
    weak var delegate : CaptureSessionCoordinatorDelegate?
    var captureSession : AVCaptureSession!
    var cameraDevice : AVCaptureDevice!
    var callBackQueue : dispatch_queue_t!

    private var sessionQueue : dispatch_queue_t!
    var previewLayer : AVCaptureVideoPreviewLayer?  {
        
        get {
            if (self.captureSession != nil) {
                
                return AVCaptureVideoPreviewLayer.init(session: captureSession)
            }else{
                return nil
            }
        }
    }

    override init() {
        super.init()
        sessionQueue = dispatch_queue_create("dispatch_queue_serial", DISPATCH_QUEUE_SERIAL)
        
        captureSession = AVCaptureSession()

        do{
            let cameraDeviceInput = try
            AVCaptureDeviceInput.init(device: AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo))
            addInput(cameraDeviceInput, captureSession: captureSession)
            
        }catch let error as NSError {
            MSGLog(Message: "\(error)")
        }
        

        do{

            let micDeviceInput = try
            AVCaptureDeviceInput.init(device: AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio))
            addInput(micDeviceInput, captureSession: captureSession)
            
        }catch let error as NSError{
            MSGLog(Message: "\(error)")
        }

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// public
extension CaptureSessionCoordinator{
    func setDelegate< T : CaptureSessionCoordinatorDelegate>(delegate : T, callBackQueue : dispatch_queue_t) {
        
        objc_sync_enter(self)
        
        self.delegate = delegate
    
        self.callBackQueue = callBackQueue
        
        objc_sync_exit(self)

    }
    
    func addInput(input : AVCaptureDeviceInput , captureSession : AVCaptureSession) -> Bool {

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
            return true
        }else{
            return false
        }
    }
    
    func addOutput(output : AVCaptureOutput , captureSession : AVCaptureSession ) -> Bool {
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
            return true
        }else{
            return false
        }
    }
    
    
    func startRecording(){
        //
    }
    
    func stopRecording(){
        //
    }
    
    final func startRunning(){
        dispatch_sync(sessionQueue) {
            self.captureSession.startRunning()
        }
    }
    
    final func stopRunning(){
        dispatch_sync(sessionQueue) {
            self.stopRecording()
            self.captureSession.stopRunning()
        }
    }
    
    // Switching between front and back cameras
    private func cameraWithPosition(position : AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices : Array = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for  device in devices{
            if let obj = device as? AVCaptureDevice {
                if obj.position == position {
                    return obj
                }
            }
        }
        return nil
    }
    
    func swapFrontAndBackCameras(){
        // Assume the session is already running
        if captureSession.running {
            
            let inputs : NSArray = captureSession.inputs
            
            for input in inputs {
                let device : AVCaptureDevice = input.device
                if device.hasMediaType(AVMediaTypeVideo) {
                    let position : AVCaptureDevicePosition = device.position
                    var newCamera : AVCaptureDevice?
                    if position == .Front {
                        newCamera = cameraWithPosition(.Back)
                    }else{
                        newCamera = cameraWithPosition(.Front)
                    }
                    
                    if let newDevice = newCamera {
                        do{
                            let newInput : AVCaptureDeviceInput = try AVCaptureDeviceInput.init(device: newDevice)
                            captureSession.beginConfiguration()
                            captureSession.removeInput(input as! AVCaptureInput)
                            captureSession.addInput(newInput)
                            captureSession.commitConfiguration()
                        }catch{
                            MSGLog(Message: "切换摄像头时，重新初始化输入设备失败！")
                        }
                    }
                }
            }
            
            
        }else{
            MSGLog(Message: "session not running!")
        }
    }
    
    /*
     - (void)swapFrontAndBackCameras {
     
     NSArray *inputs = self.session.inputs;
     for ( AVCaptureDeviceInput *input in inputs ) {
     AVCaptureDevice *device = input.device;
     if ( [device hasMediaType:AVMediaTypeVideo] ) {
     AVCaptureDevicePosition position = device.position;
     AVCaptureDevice *newCamera = nil;
     AVCaptureDeviceInput *newInput = nil;
     
     if (position == AVCaptureDevicePositionFront)
     newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
     else
     newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
     newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
     
     // beginConfiguration ensures that pending changes are not applied immediately
     [self.session beginConfiguration];
     
     [self.session removeInput:input];
     [self.session addInput:newInput];
     
     // Changes take effect once the outermost commitConfiguration is invoked.
     [self.session commitConfiguration];
     break;
     }
     }
     }

     */

}







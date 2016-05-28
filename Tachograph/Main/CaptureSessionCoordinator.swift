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

}







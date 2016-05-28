//
//  CaptureSessionMovieFileOutputCoordinator.swift
//  Tachograph
//
//  Created by Ethan on 16/5/20.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary


class CaptureSessionMovieFileOutputCoordinator: CaptureSessionCoordinator {
    
    var movieFileOutput : AVCaptureMovieFileOutput!
    
    override init() {
        super.init()

        movieFileOutput = AVCaptureMovieFileOutput()
        if !addOutput(movieFileOutput, captureSession: captureSession) {
            MSGLog(Message: "movieFileOutput 添加失败 ！")
        }
    }

    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
    
    // override
    override func startRecording() {
        // 开始录制保存的路径
        let path : NSURL? = FileManager.createFileUrl()
        if  let  pathStr = path{
            
            self.movieFileOutput.startRecordingToOutputFileURL(pathStr, recordingDelegate: self)
        }
    }
    
    override func stopRecording() {

        movieFileOutput.stopRecording()

    }
}

extension CaptureSessionMovieFileOutputCoordinator : AVCaptureFileOutputRecordingDelegate{
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!){
        
        self.delegate?.coordinatorDidBeginRecording(self)
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!){
        
        self.delegate?.coordinatorDidFinishRecording(self, outputFileURL: outputFileURL, error)

    }
}

//
//  CaptureView.swift
//  Tachograph
//
//  Created by Ethan on 16/5/5.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureView: UIView {
    
    weak var captureManager : CaptureManager? = CaptureManager.sharedInstance()

    weak var preL : AVCaptureVideoPreviewLayer?
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.blackColor()
        
        preL = captureManager?.prelayer()
        
        if let prelayer = preL where preL != nil {
            self.layer.addSublayer(prelayer)
        }
        
        // 屏幕变化通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CaptureView.deviceOrientationDidChange) , name: UIDeviceOrientationDidChangeNotification, object: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        preL?.frame = self.bounds
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

// 用来记录这一次旋转到的状态，等旋转到最上面的时候可以计算清楚
private var orientationTemp  : AVCaptureVideoOrientation = .Portrait

extension CaptureView{
    
    @objc private func deviceOrientationDidChange(){
        let orientation : UIDeviceOrientation = UIDevice.currentDevice().orientation

        // 方向旋转  对应的显示屏幕旋转 非录制输入屏幕方向
        if UIDeviceOrientationIsPortrait(orientation) || UIDeviceOrientationIsLandscape(orientation)
        {
            var videoOrientation : AVCaptureVideoOrientation = .Portrait
            
            switch orientation {
            case .LandscapeLeft:
                videoOrientation = .LandscapeRight
            case .LandscapeRight:
                videoOrientation = .LandscapeLeft
            case .FaceUp:
                videoOrientation = .PortraitUpsideDown
            case .FaceDown:
                videoOrientation = .Portrait
            case .PortraitUpsideDown:
                // 当屏幕上下颠倒的时候
                if orientationTemp == .LandscapeLeft {

                    videoOrientation = .LandscapeLeft
                }else if orientationTemp == .LandscapeRight{
                    videoOrientation = .LandscapeRight
                }
            case .Portrait:
                videoOrientation = .Portrait
            case .Unknown:
                videoOrientation = .Portrait
            }
            
            preL?.connection.videoOrientation = videoOrientation
            orientationTemp = videoOrientation
        }
        
    }
    
}

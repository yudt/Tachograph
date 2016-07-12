//
//  MainView.swift
//  Tachograph
//
//  Created by Ethan on 16/5/5.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

private let margin : CGFloat = 8
private let mapviewWH : CGFloat = 90



@objc protocol MainViewDelegate : NSObjectProtocol{
    
    optional func MainViewOverlayTabbarClicked(index : Int,_ selected : Bool)
    
}

class MainView: UIView {

    weak var delegate : MainViewDelegate?
    /**
     *  地图页面
     */
    private let mapView = MapView()
    
    /**
     *  摄像头显示区域
     */
    private let captureView = CaptureView()
    
    /**
     *  导航条
     */
    let tabbar : TabbarView = TabbarView()

    
    
    /**
     *  摄像头 地图切换的中间button  添加到基础视图，放置在顶部
     */
    private let rectButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        backgroundColor = UIColor.blackColor()
        mapView.frame = frame
        captureView.frame = frame
        rectButton.frame = CGRectMake(0, 0, mapviewWH, mapviewWH)
        rectButton.layer.cornerRadius = 15
        rectButton.layer.masksToBounds = true
        rectButton.alpha = 0.4
        rectButton.addTarget(self, action: #selector(MainView.changeMapCaptureFrameValueAction(_:)), forControlEvents: .TouchUpInside)
        rectButton.selected = true // true map.frame == rectButton   |||| false captureView.frame == rectButton
        // 添加初始化的小视图位置
        if bounds.size.width > bounds.size.height {
            // 当横向 在右下角
            rectButton.frame = CGRectMake(bounds.size.width - rectButton.frame.size.width - margin,bounds.size.height - rectButton.frame.size.height - margin, rectButton.bounds.size.width, rectButton.bounds.size.height)
            
        }else{
            rectButton.frame = CGRectMake(bounds.size.width - rectButton.frame.size.width - margin, bounds.size.height - rectButton.frame.size.height - margin - tabbarH, rectButton.bounds.size.width, rectButton.bounds.size.height)
        }
        
        if rectButton.selected {
            addSubview(captureView)
            addSubview(mapView)
        }else{
            addSubview(mapView)
            addSubview(captureView)
        }
        changeMapCaptureFrameValueAction(rectButton)
        addSubview(tabbar)
        addSubview(rectButton)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainView.deviceOrientationDidChangeNotificationAction(_:)), name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
        // delegate tabbarButtonAction
        for obj in tabbar.buttonArr {
            if obj.isKindOfClass(UIButton) {
            obj.addTarget(self, action: #selector(MainView.buttonAction(_:)), forControlEvents: .TouchUpInside)
            }
        }
        
        // 配置相关 ，后续加上
//     MSGLog(Message: "是否显示小地图\(AppConfigure.sharedConfigure().showSmallMap)")
//        
//        let appconfig = AppConfigure.sharedConfigure()
//        appconfig.showSmallMap = false
//        appconfig.synchronize()
//        MSGLog(Message: "\(appconfig.showSmallMap)")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 横屏
        if bounds.size.width > bounds.size.height {
            tabbar.frame = CGRectMake(0, 0, tabbarH, bounds.size.height)
        }else{
            tabbar.frame = CGRectMake(0, bounds.size.height - tabbarH, bounds.size.width, tabbarH)
        }
        
        bringSubviewToFront(rectButton)
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


extension MainView{
    
    @objc private func buttonAction(btn : UIButton) {

        btn.selected = !btn.selected
        delegate?.MainViewOverlayTabbarClicked?(btn.tag - 6122,btn.selected)
    }
    
    @objc private func changeMapCaptureFrameValueAction(btn : UIButton) {
        
        btn.selected = !btn.selected
        
        UIView.animateWithDuration(0.3, animations: {
            
                if btn.selected{
                    self.mapView.frame = self.bounds
                    self.mapView.layer.cornerRadius = 0
                    self.mapView.layer.masksToBounds = false
                }else{
                    self.captureView.frame = self.bounds
                    self.captureView.layer.cornerRadius = 0
                    self.captureView.layer.masksToBounds = false
                }
            
            }) { (over) in
                
                if btn.selected{
                    self.captureView.frame = btn.frame
                    self.captureView.layer.cornerRadius = 15
                    self.captureView.layer.masksToBounds = true
                    self.sendSubviewToBack(self.mapView)
                }else{
                    self.mapView.frame = btn.frame
                    self.mapView.layer.cornerRadius = 15
                    self.mapView.layer.masksToBounds = true
                    self.sendSubviewToBack(self.captureView)
                }
                
        }
    }
    
    @objc private func deviceOrientationDidChangeNotificationAction(noti : NSNotification){
        
        if rectButton.selected{
            self.mapView.frame = self.bounds
            self.mapView.layer.cornerRadius = 0
            self.mapView.layer.masksToBounds = false
            self.captureView.frame = rectButton.frame
            self.captureView.layer.cornerRadius = 15
            self.captureView.layer.masksToBounds = true
            self.sendSubviewToBack(self.mapView)
        }else{
            self.captureView.frame = self.bounds
            self.captureView.layer.cornerRadius = 0
            self.captureView.layer.masksToBounds = false
            self.mapView.frame = rectButton.frame
            self.mapView.layer.cornerRadius = 15
            self.mapView.layer.masksToBounds = true
            self.sendSubviewToBack(self.captureView)
        }
    }
    
}

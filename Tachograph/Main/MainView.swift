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
     *  遮盖物视图
     */
    private let overlayView = OverlayView()
    
    
    /**
     *  摄像头 地图切换的中间button  添加到基础视图，放置在顶部
     */
    private let rectButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.blackColor()
        mapView.frame = frame
        captureView.frame = frame
        overlayView.frame = frame
        
        self.addSubview(captureView)
        self.addSubview(mapView)
        self.addSubview(overlayView)
        self.addSubview(rectButton)
        mapView.frame = CGRectMake(0, 0, mapviewWH, mapviewWH)
        mapView.layer.cornerRadius = 15
        mapView.layer.masksToBounds = true
        rectButton.alpha = 0.4
        
        // delegate tabbarButtonAction
        for obj in overlayView.tabbar.buttonArr {
            if obj.isKindOfClass(UIButton) {
            obj.addTarget(self, action: #selector(MainView.buttonAction(_:)), forControlEvents: .TouchUpInside)
            }
        }
        
     MSGLog(Message: "是否显示小地图\(AppConfigure.sharedConfigure().showSmallMap)")
        
        let appconfig = AppConfigure.sharedConfigure()
        appconfig.showSmallMap = false
        appconfig.synchronize()
        MSGLog(Message: "\(appconfig.showSmallMap)")
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 横屏
        if self.bounds.size.width > self.bounds.size.height {
            // 当横向 在右下角
            mapView.frame = CGRectMake(self.bounds.size.width - mapView.frame.size.width - margin, self.bounds.size.height - mapView.frame.size.height - margin, mapView.bounds.size.width, mapView.bounds.size.height)

        }else{
            mapView.frame = CGRectMake(self.bounds.size.width - mapView.frame.size.width - margin, self.bounds.size.height - mapView.frame.size.height - margin - tabbarH, mapView.bounds.size.width, mapView.bounds.size.height)
        }
        
        rectButton.frame = mapView.frame
        captureView.frame = self.bounds
        overlayView.frame = self.bounds
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
    
    @objc private func buttonAction(btn : UIButton){

        btn.selected = !btn.selected
        delegate?.MainViewOverlayTabbarClicked?(btn.tag - 6122,btn.selected)
    }
    
}

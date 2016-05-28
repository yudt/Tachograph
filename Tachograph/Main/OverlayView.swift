//
//  OverlayView.swift
//  Tachograph
//
//  Created by Ethan on 16/5/5.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

class OverlayView: UIView {

    let tabbar : TabbarView = TabbarView()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        addSubview(tabbar)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // 横屏
        if self.bounds.size.width > self.bounds.size.height {
            tabbar.frame = CGRectMake(0, 0, tabbarH, self.bounds.size.height)
        }else{
            tabbar.frame = CGRectMake(0, self.bounds.size.height - tabbarH, self.bounds.size.width, tabbarH)
        }
        
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

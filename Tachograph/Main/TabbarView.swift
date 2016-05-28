//
//  TabbarView.swift
//  Tachograph
//
//  Created by Ethan on 16/5/5.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

// 6个tabbar按钮
private let btnCount : Int = 6
private let marginSpace : CGFloat = 3
private let margin2W : CGFloat = 2

class TabbarView: UIView {
    
    // 事件代理
    var buttonArr : [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        self.backgroundColor = UIColor(red:0.75, green:0.72, blue:0.73, alpha:0.5)
        for i in 0..<btnCount {
            let btn : TabBarItem
            if i != 5 {
                btn  = TabBarItem(Image:"\(i)","\(i)")
            }else{
                btn  = TabBarItem(Image:"\(i)","\(i)\(i)")
            }
            btn.frame = CGRectZero
            btn.tag = i + 6122
            addSubview(btn)
            buttonArr.append(btn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var width : CGFloat = 0
        var height : CGFloat = 0
        
        if self.frame.size.width > self.frame.size.height {
            // 竖屏
            width = (self.frame.size.width - marginSpace * CGFloat(buttonArr.count + 1) ) / CGFloat(buttonArr.count)
            
            height = self.frame.size.height
            
            for i in 0..<buttonArr.count {
                let obj : UIButton = buttonArr[i]
                obj.frame = CGRectMake(CGFloat(i) * (width + marginSpace) + marginSpace, margin2W, width, height - margin2W * CGFloat(2))
            }
            
        }else{
            // 横屏
            width = self.frame.size.width
            height = (self.frame.size.height - marginSpace * CGFloat(buttonArr.count + 1) ) / CGFloat(buttonArr.count)
            for i in 0..<buttonArr.count {
                let obj : UIButton = buttonArr[i]
                obj.frame = CGRectMake(margin2W, CGFloat(i) * (height + marginSpace) + marginSpace, width - margin2W * CGFloat(2), height)
            }
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


private class TabBarItem: UIButton {
    
    var aImage : UIImage!
    var aSelImage : UIImage!
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        
    }
    
    convenience init(Image image: String , _ selImage: String){
        self.init(frame: CGRectZero)
        backgroundColor = UIColor.clearColor()
        
        setImage(UIImage.init(ASName: image, directory: "Tabbar"), forState: .Normal)
        setImage(UIImage.init(ASName: selImage, directory: "Tabbar"), forState: .Selected)
        
//        self.contentMode = .ScaleAspectFit
        self.imageView?.contentMode = .ScaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        
    }
    
    
}
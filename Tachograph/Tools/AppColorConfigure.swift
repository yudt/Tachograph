//
//  AppColorConfigure.swift
//  Tachograph
//
//  Created by Ethan on 16/5/4.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

class AppColorConfigure: NSObject {

}


//  **********
func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func UIColorFromRGBString(colorString: String?) -> UIColor? {
    
    // 检查字符串是否为空和位数是否正确
    if colorString == nil || colorString!.utf16.count != 6 {
        
        return nil
    }
    
    // 将字符串转换成rgb
    var red = 0
    var green = 0
    var blue = 0
    
    for i in 0...2 {
        
        let range = colorString!.startIndex.advancedBy(i*2) ..< colorString!.startIndex.advancedBy(i*2+2)
        
        let colorSegment = colorString!.substringWithRange(range)
        
        let colorNumber = strtol(colorSegment, nil, 16)
        
        switch i {
        case 0:
            red = colorNumber
        case 1:
            green = colorNumber
        case 2:
            blue = colorNumber
        default:
            break
        }
    }
    
    return RGBA(CGFloat(red), g: CGFloat(green), b: CGFloat(blue), a: 1.0)
}

func RGBStringFromUIColor(color: UIColor) -> String? {
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    
    if color.getRed(&red, green: &green, blue: &blue, alpha: nil) {
        
        let redInt = Int(floor(red * 255.0))
        let greenInt = Int(floor(green * 255.0))
        let blueInt = Int(floor(blue * 255.0))
        
        return String(format:"%02x%02x%02x", redInt, greenInt, blueInt)
    }
    else {
        
        return nil
    }
}
//
//  main.swift
//  MainApplication
//
//  Created by admin on 16/2/26.
//  Copyright © 2016年 OwnersCircle. All rights reserved.
//

import Foundation
import UIKit

// 监听事件
class MyApplication: UIApplication {
    override func sendEvent(event : UIEvent){
        super.sendEvent(event)
//        MSGLog(Message: "event sent : \(event)")
    }
}

UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(MyApplication), NSStringFromClass(AppDelegate))

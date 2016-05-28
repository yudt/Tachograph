//
//  AppConfigure.swift
//  Tachograph
//
//  Created by Ethan on 16/5/5.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit


class AppConfigure: NSObject {

    /**
     *  存储对象
     */
    var configures : NSMutableDictionary!
    
    
    // URLPATH
    // /Documents/appconfig/app.cfg
    private let urlPath : String = GHConst.GetPathForDocuments("app.cfg", inDir: "appconfig")
    
    
    private static let sharedInstance : AppConfigure = {

        return AppConfigure()
        
    }()
    
    class func sharedConfigure() -> AppConfigure{
        
        return sharedInstance
        
    }
    
    
    // 存储列表
    // 是否显示小地图
    var showSmallMap : Bool = true
    
    
    
    
    private override init(){
        MSGLog(Message: urlPath)

        let dicts : NSMutableDictionary? = NSMutableDictionary(contentsOfFile: urlPath as String)
        
        if let configures = dicts {
            self.configures = configures
        }else{
            configures = NSMutableDictionary(capacity: 40)
        }
        super.init()
        load()
    }
    
    // 取
    private func load(){
        
        if configures.count > 0 {
            showSmallMap = configures.objectForKey("showSmallMap") as! Bool
        }else{
            // 若没初值，在这里重新赋值
        }
        
    }

    
    // 同步
    func synchronize(){
        configures.setObject(showSmallMap, forKey: "showSmallMap")
    }
    

    
    // 清空
    func cleanAllObjects(){
        GHConst.deleteWithFilePath(urlPath)
    }
    
}

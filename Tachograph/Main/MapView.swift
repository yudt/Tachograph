//
//  MapView.swift
//  Tachograph
//
//  Created by Ethan on 16/5/5.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit



class MapView: UIView {
    
    let mapView : MAMapView = MAMapView(frame : CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.blackColor()
        
        setMapView()
        self.addSubview(mapView)
    }
    
    
    func setMapView(){
        
        mapView.delegate = self
        //        mapView.language = .En // 英文，没什么卵用
        mapView.showsUserLocation = true // 打开定位
        /*
         MAUserTrackingModeNone：仅在地图上显示，不跟随用户位置。
         MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点。
         MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动。
         */
        mapView.setUserTrackingMode(.Follow, animated: true)
        mapView.setZoomLevel(6, animated: true)
        
        // 后台定位
        mapView.pausesLocationUpdatesAutomatically = false // 不自动暂停
        mapView.allowsBackgroundLocationUpdates = true // 是否自动定位
        
        // 实时路况
        mapView.showTraffic = true
        
        /*
         1）普通地图 MAMapTypeStandard；
         2）卫星地图 MAMapTypeSatellite；
         3）夜间地图 MAMapTypeStandardNight；
         */
        mapView.mapType = .Standard
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = self.bounds
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

public let pointReuseIndentifier = "pointReuseIndentifier"

extension MapView : MAMapViewDelegate{
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation {
            MSGLog(Message: "latitude(维度) : \(userLocation.coordinate.latitude),longitude(精度):\(userLocation.coordinate.longitude)")
        }
    }
//    // 打点
//    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
//        
//        if annotation.isKindOfClass(MAPointAnnotation)
//        {
//            var annotationView : MAAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(pointReuseIndentifier)
//            if annotationView == nil {
//                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
//                annotationView?.canShowCallout = true // 可以弹出气泡
//                annotationView?.draggable = true // 是否支持拖动
//                return annotationView
//            }
//        }
//        return nil
//    }
}





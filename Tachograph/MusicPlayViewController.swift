//
//  MusicPlayViewController.swift
//  Tachograph
//
//  Created by  mapbar_ios on 16/7/12.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

class MusicPlayViewController: UIViewController{

    var filePath:String = ""
    var playBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Custom Methods
    func setupUI() {
        
        view.backgroundColor = UIColor.blackColor()
        let bgImageView = UIImageView(image: UIImage(ASName: "演员", directory: "Music", type: "jpg"))
        bgImageView.alpha = 0.6
        view.addSubview(bgImageView)
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        let bgHCons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[image]-0-|", options: .AlignmentMask, metrics: nil, views: ["image":bgImageView])
        let bgVCons = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[image]-0-|", options: .AlignmentMask, metrics: nil, views: ["image":bgImageView])
        view.addConstraints(bgHCons)
        view.addConstraints(bgVCons)
        
        let preBtn = UIButton()
        preBtn.setTitle("上一首", forState: .Normal)
        preBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        preBtn.layer.masksToBounds = true
        preBtn.layer.cornerRadius = 5
        preBtn.backgroundColor = UIColor.blueColor()
        preBtn.addTarget(self, action: #selector(playPre), forControlEvents: .TouchUpInside)
        preBtn.translatesAutoresizingMaskIntoConstraints = false
        let widthCon = NSLayoutConstraint(item: preBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60)
        let heightCon = NSLayoutConstraint(item: preBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40)
        let centerXCon = NSLayoutConstraint(item: preBtn, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 0.5, constant: 0)
        let bottomCon = NSLayoutConstraint(item: preBtn, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -30)
        view.addSubview(preBtn)
        view.addConstraints([widthCon,heightCon,centerXCon,bottomCon])
        
        playBtn.setTitle("播放", forState: .Normal)
        playBtn.setTitleColor(UIColor.redColor(), forState: .Normal)
        playBtn.layer.masksToBounds = true
        playBtn.layer.cornerRadius = 5
        playBtn.backgroundColor = UIColor.blueColor()
        playBtn.addTarget(self, action: #selector(play), forControlEvents: .TouchUpInside)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        let playWidthCon = NSLayoutConstraint(item: playBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60)
        let playHeightCon = NSLayoutConstraint(item: playBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40)
        let playCenterXCon = NSLayoutConstraint(item: playBtn, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        let playBottomCon = NSLayoutConstraint(item: playBtn, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -30)
        view.addSubview(playBtn)
        view.addConstraints([playWidthCon,playHeightCon,playCenterXCon,playBottomCon])
        
        let nextBtn = UIButton()
        nextBtn.setTitle("下一首", forState: .Normal)
        nextBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        nextBtn.backgroundColor = UIColor.blueColor()
        nextBtn.addTarget(self, action: #selector(playNext), forControlEvents: .TouchUpInside)
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        let nextWidthCon = NSLayoutConstraint(item: nextBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60)
        let nextHeightCon = NSLayoutConstraint(item: nextBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40)
        let nextCenterXCon = NSLayoutConstraint(item: nextBtn, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.5, constant: 0)
        let nextBottomCon = NSLayoutConstraint(item: nextBtn, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -30)
        view.addSubview(nextBtn)
        view.addConstraints([nextWidthCon,nextHeightCon,nextCenterXCon,nextBottomCon])
        
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "down"), forState: .Normal)
        backBtn.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        view.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        let backLeadingCon = NSLayoutConstraint(item: backBtn, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 20)
        let backTopCon = NSLayoutConstraint(item: backBtn, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 8)
        let backWidthCon = NSLayoutConstraint(item: backBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40)
        let backHeightCon = NSLayoutConstraint(item: backBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 40)
        view.addConstraints([backTopCon,backLeadingCon,backWidthCon,backHeightCon])
    }
    

    //MARK:Touch Methods
    @objc func playPre() {
        TaMusicPlayer.sharedSingleton().playPre()
    }
    
    @objc func play() {
        TaMusicPlayer.sharedSingleton().play()
    }
    
    @objc func playNext() {
        TaMusicPlayer.sharedSingleton().playNext()
    }
    @objc func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

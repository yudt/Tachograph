//
//  MusicPlayViewController.swift
//  Tachograph
//
//  Created by  mapbar_ios on 16/7/12.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicPlayViewController: UIViewController,AVAudioPlayerDelegate{

    var filePath:String!
    var player:AVAudioPlayer?{
        if self.player == nil {
            return try? setupPlayerWithUrl(NSURL.fileURLWithPath(filePath))
        }
        return self.player
    }

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
        
    }
    
    func setupPlayerWithUrl(url:NSURL) -> AVAudioPlayer? {
        do{
            let audioPlayer = try AVAudioPlayer.init(contentsOfURL: url)
            //设置播放器属性
            audioPlayer.numberOfLoops = 0//设置为0不循环
            audioPlayer.delegate = self;
            audioPlayer.prepareToPlay()//加载音频文件到缓存
            return audioPlayer
        } catch {
            return nil
        }
    }
    //AV
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}

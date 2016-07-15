//
//  TaMusicPlayer.swift
//  Tachograph
//
//  Created by  mapbar_ios on 16/7/13.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import Foundation
import MediaPlayer
@objc protocol TaMusicPlayerDelegate {
    optional func playerCurrentIndexDidChange(index:Int)
    optional func playerDidSelectPlayBtn(play:Bool)
}
class TaMusicPlayer:NSObject,AVAudioPlayerDelegate {
    static var singleton:TaMusicPlayer? = nil//单例
    private var player:AVAudioPlayer?//播放器
    var filePaths:[String] = []//初始值
    var currentIndex = 0//当前播放的音乐的index
    var index = Int.max//上个页面传过来的index
    var listDelegate:TaMusicPlayerDelegate?
    var detailDelegate:TaMusicPlayerDelegate?
    class func sharedSingleton() -> TaMusicPlayer{
        if singleton == nil {
            singleton = TaMusicPlayer()
        }
        return singleton!
    }

    
    func play(){
        guard let player = self.player else {
            self.player = try? AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(filePaths[currentIndex]))
            self.player?.numberOfLoops = 0
            self.player?.delegate = self
            self.player?.play()
            return
        }
        
        if player.playing {
            player.pause()
            detailDelegate?.playerDidSelectPlayBtn?(false)
        }else{
            player.play()
            detailDelegate?.playerDidSelectPlayBtn?(true)
        }
        
    }
    
    func playNext(){
        if currentIndex + 1 >= filePaths.count {
            currentIndex = 0
        }else{
            currentIndex += 1
        }
        player = nil
        play()
        if player != nil {
            listDelegate?.playerCurrentIndexDidChange?(currentIndex)
        }
    }
    
    func playPre(){
        if currentIndex - 1 < 0 {
            currentIndex = filePaths.count - 1
        }else{
            currentIndex -= 1
        }
        player = nil
        play()
        if player != nil {
            listDelegate?.playerCurrentIndexDidChange?(currentIndex)
        }
    }
    //MARK:AV
    @objc func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool){
        
    }
    
}
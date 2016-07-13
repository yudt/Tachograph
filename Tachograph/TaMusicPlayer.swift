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
}
class TaMusicPlayer:NSObject,AVAudioPlayerDelegate {
    static var singleton:TaMusicPlayer? = nil//单例
    private var player:AVAudioPlayer?//播放器
    var filePaths:[String] = []//初始值
    var currentIndex = 0//当前播放的音乐的index
    var delegate:TaMusicPlayerDelegate?
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
        }else{
            player.play()
        }
    }
    
    func playNext(){
        if currentIndex + 1 >= filePaths.count {
            currentIndex = 0
        }else{
            currentIndex += 1
        }
        let next = filePaths[currentIndex]
        player = try? AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(next))
        player?.numberOfLoops = 0
        player?.delegate = self
        player?.prepareToPlay()
        player?.play()
        if player != nil {
            delegate?.playerCurrentIndexDidChange?(currentIndex)
        }
    }
    
    func playPre(){
        if currentIndex - 1 < 0 {
            currentIndex = filePaths.count - 1
        }else{
            currentIndex -= 1
        }
        let pre = filePaths[currentIndex]
        player = try? AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(pre))
        player?.numberOfLoops = 0
        player?.delegate = self
        player?.prepareToPlay()
        player?.play()
        if player != nil {
            delegate?.playerCurrentIndexDidChange?(currentIndex)
        }
    }
    //MARK:AV
    @objc func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool){
        
    }
}
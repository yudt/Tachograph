//
//  MoviePlayerController.swift
//  Tachograph
//
//  Created by Ethan on 16/7/11.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import MediaPlayer

class MoviePlayerController: UIViewController {
    
    var fileUrl : NSString?

    private var moviePlayerView : MPMoviePlayerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let str = fileUrl {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MoviePlayerController.playingDone), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
            
            moviePlayerView = MPMoviePlayerViewController(contentURL:NSURL(fileURLWithPath: str as String))
            moviePlayerView.moviePlayer.controlStyle = .Fullscreen
            moviePlayerView.moviePlayer.scalingMode = .AspectFill
            
            view.addSubview(moviePlayerView.view)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MoviePlayerController{
    
    @objc private func playingDone(){
        moviePlayerView.view.removeFromSuperview()
        moviePlayerView = nil
        self.navigationController?.popViewControllerAnimated(false)
    }
    
}

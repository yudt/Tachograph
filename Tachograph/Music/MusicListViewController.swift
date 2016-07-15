//
//  MusicListViewController.swift
//  Tachograph
//
//  Created by  mapbar_ios on 16/7/12.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import FreeStreamer

class MusicListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,TaMusicPlayerDelegate {

    var playlistItems:[FSPlaylistItem] = []

    let tableView = UITableView()
    let reuse = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        requireLocalSongsAndReload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TaMusicPlayer.sharedSingleton().listDelegate = nil
    }
    //MARK:Custom Methods
    func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let hs = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableview]-0-|", options: .AlignmentMask, metrics: nil, views: ["tableview":tableView])
        let vs = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tableview]-0-|", options: .AlignmentMask, metrics: nil, views: ["tableview":tableView])
        view.addConstraints(hs)
        view.addConstraints(vs)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func requireLocalSongsAndReload() {
        
    }
    
    func getSongFilePath(filePath:String) -> String{
        let bundlePath = NSBundle.mainBundle().pathForResource("Resources", ofType: "bundle")!
        return  NSBundle(path: bundlePath)!.pathForResource(filePath, ofType: "mp3", inDirectory: "Music")!
        
    }

    //MARK:TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuse)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: reuse)
        }
//        cell?.textLabel?.text = songTitles[indexPath.row]
        cell?.selectionStyle = .Gray
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = MusicPlayViewController()
        TaMusicPlayer.sharedSingleton().listDelegate = self
        TaMusicPlayer.sharedSingleton().detailDelegate = controller
        TaMusicPlayer.sharedSingleton().currentIndex = indexPath.row
        if TaMusicPlayer.sharedSingleton().index != indexPath.row {
            presentViewController(controller, animated: true) {
                TaMusicPlayer.sharedSingleton().play()
                TaMusicPlayer.sharedSingleton().index = indexPath.row
            }
        }else{
            presentViewController(controller, animated: true, completion: nil)
        }
        
        
    }
    //MARK:TA
    func playerCurrentIndexDidChange(index:Int){
        print("唱到\(index)");
        tableView.selectRowAtIndexPath(NSIndexPath.init(forRow: index, inSection: 0), animated: true, scrollPosition: .Top)
        TaMusicPlayer.sharedSingleton().index = index
    }

}

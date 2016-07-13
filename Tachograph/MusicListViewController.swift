//
//  MusicListViewController.swift
//  Tachograph
//
//  Created by  mapbar_ios on 16/7/12.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,TaMusicPlayerDelegate {

    let tableView = UITableView()
    let reuse = "Cell"
    var songfilePaths:[String] = []
    var songTitles:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        requireLocalSongsAndReload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let songFilePath1 = getSongFilePath("莉莉安")
        songfilePaths.append(songFilePath1)
        songTitles.append("莉莉安")
        let songFilePath2 = getSongFilePath("生活不止眼前的苟且")
        songfilePaths.append(songFilePath2)
        songTitles.append("生活不止眼前的苟且")
        TaMusicPlayer.sharedSingleton().filePaths = songfilePaths
    }
    
    func getSongFilePath(filePath:String) -> String{
        let bundlePath = NSBundle.mainBundle().pathForResource("Resources", ofType: "bundle")!
        return  NSBundle(path: bundlePath)!.pathForResource(filePath, ofType: "mp3", inDirectory: "Music")!
        
    }

    //MARK:TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songfilePaths.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuse)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: reuse)
        }
        cell?.textLabel?.text = songTitles[indexPath.row]
        cell?.selectionStyle = .None
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = MusicPlayViewController()
        controller.filePath = songfilePaths[indexPath.row]
        TaMusicPlayer.sharedSingleton().delegate = self
        presentViewController(controller, animated: true, completion: nil)
    }
    //MARK:TA
    func playerCurrentIndexDidChange(index:Int){
        tableView.selectRowAtIndexPath(NSIndexPath.init(forRow: index, inSection: 0), animated: true, scrollPosition: .Top)
    }

}

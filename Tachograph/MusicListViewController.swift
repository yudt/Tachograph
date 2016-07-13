//
//  MusicListViewController.swift
//  Tachograph
//
//  Created by  mapbar_ios on 16/7/12.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let tableView = UITableView()
    let reuse = "Cell"
    var songs:[MPMediaItem] = []
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let hs = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableview]-0-|", options: .AlignmentMask, metrics: nil, views: ["tableview":tableView])
        let vs = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tableview]-0-|", options: .AlignmentMask, metrics: nil, views: ["tableview":tableView])
        view.addSubview(tableView)
        view.addConstraints(hs)
        view.addConstraints(vs)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func requireLocalSongsAndReload() {
        let query = MPMediaQuery.songsQuery()
        guard let items = query.items else{
            return
        }
        for item in items {
            songs.append(item)
        }
        tableView.reloadData()
    }
    //MARK:AVPlayer
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    //MARK:TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuse)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: reuse)
        }
        cell?.textLabel?.text = songs[indexPath.row].title
        cell?.selectionStyle = .None
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = MusicPlayViewController()
        controller.item = songs[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    

}

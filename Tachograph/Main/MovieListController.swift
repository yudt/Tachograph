//
//  MovieListController.swift
//  Tachograph
//
//  Created by Ethan on 16/7/11.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

class MovieListController: UIViewController {
    
    private var tableView : UITableView!
    var dataSource : [VideoModel]!
    
    
    override func loadView() {
        tableView  = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view = tableView

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "视频"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension MovieListController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "CellID"
        
        var cell : UITableViewCell? =  tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: identifier)
        }
        
        cell?.imageView?.image = dataSource[indexPath.row].videoImage
        var textLabelStr : NSString = dataSource[indexPath.row].filePath!
        let strArr = textLabelStr.componentsSeparatedByString("/")
        textLabelStr = strArr[strArr.count - 1]
        cell?.textLabel?.text = textLabelStr as String
        cell?.detailTextLabel?.text = "文件的大小为：\(dataSource[indexPath.row].fileSize)"
        
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataSource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let movie = MoviePlayerController()
        
        movie.fileUrl = dataSource[indexPath.row].filePath

        self.navigationController?.pushViewController(movie, animated: false)
        
    }


}



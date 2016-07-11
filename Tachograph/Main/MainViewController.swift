//
//  MainViewController.swift
//  Tachograph
//
//  Created by Ethan on 16/5/4.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var mainView : MainView!

    override func loadView() {
        mainView = MainView(frame : Screen)
        view = mainView
        mainView.delegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
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

extension MainViewController : MainViewDelegate{
    
    func MainViewOverlayTabbarClicked(index: Int, _ selected: Bool) {
        MSGLog(Message: "Tabbar -> MainViewController: 第index:\(index)个图标,是否为选中状态:selected :\(selected)")
        
        // 录像
        if index == 5  {
            if selected {
                CaptureManager.sharedInstance().starRecording()
            }else{
                CaptureManager.sharedInstance().stopRecording()

            }
        }else if index == 2{
            let arr = FileManager.VideoModels()
            
            if let datasource = arr{
                let movieListController = MovieListController()
                movieListController.dataSource = datasource
                self.navigationController?.navigationBarHidden = false
                self.navigationController?.pushViewController(movieListController, animated: true)
            }else{
                MSGLog(Message: "nothing");
            }
            
        }
        
        
    }
    
}

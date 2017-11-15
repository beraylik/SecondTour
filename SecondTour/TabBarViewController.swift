//
//  TabBarViewController.swift
//  SecondTour
//
//  Created by Gena Beraylik on 12.11.2017.
//  Copyright © 2017 Beraylik. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let voyagerTab = VoyagerViewController()
        let voyagerNavi = UINavigationController(rootViewController: voyagerTab)
        let voyagerBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        voyagerNavi.tabBarItem = voyagerBarItem
        
        let historyTab = HistoryTableViewController()
        let historyNavi = UINavigationController(rootViewController: historyTab)
        let historyBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        historyNavi.tabBarItem = historyBarItem
        
        self.viewControllers = [voyagerNavi, historyNavi]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

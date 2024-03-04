//
//  ViewController.swift
//  Tracker
//
//  Created by Admin on 09.01.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        let border = CALayer()
        border.backgroundColor = UIColor.ypGray.cgColor
        border.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1)
        tabBar.layer.addSublayer(border)
        
        let trackersViewCotroller = TrackersViewController()
        let navigationController = UINavigationController(rootViewController: trackersViewCotroller)
        
        let titleTrackersText = NSLocalizedString("trackers.tabBarItem.title", comment: "")
        navigationController.tabBarItem = UITabBarItem(title: titleTrackersText,
                                                       image: UIImage(named: "trackersVCIcon"),
                                                       selectedImage: nil)
       
        let titleStatisticsText = NSLocalizedString("statistics.tabBarItem.title", comment: "")
        let statisticsViewCotroller = StatisticsViewController()
        statisticsViewCotroller.tabBarItem = UITabBarItem(title: titleStatisticsText,
                                                          image: UIImage(named: "statisticsVCIcon"),
                                                          selectedImage: nil)
        
        self.viewControllers = [navigationController, statisticsViewCotroller]
    }
}


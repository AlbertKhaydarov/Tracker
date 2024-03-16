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
        setuoTabViews()
        setupBorder()
    }
    
    private func setupBorder() {
        let border = UIView()
        border.backgroundColor = UIColor.ypLine
        border.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1)
        tabBar.addSubview(border)
        tabBar.clipsToBounds = true
    }
    
    private func setuoTabViews() {
        let trackersViewCotroller = TrackersViewController()
        let trackersViewCotrollerNavigationController = UINavigationController(rootViewController: trackersViewCotroller)
        
        let titleTrackersText = NSLocalizedString("trackers.tabBarItem.title", comment: "")
        trackersViewCotrollerNavigationController.tabBarItem = UITabBarItem(title: titleTrackersText,
                                                                            image: UIImage(named: "trackersVCIcon"),
                                                                            selectedImage: nil)
        
        let titleStatisticsText = NSLocalizedString("statistics.tabBarItem.title", comment: "")
        let statisticsViewCotroller = StatisticsViewController()
        let statisticsViewCotrollerNavigationController = UINavigationController(rootViewController: statisticsViewCotroller)
        statisticsViewCotrollerNavigationController.tabBarItem = UITabBarItem(title: titleStatisticsText,
                                                                              image: UIImage(named: "statisticsVCIcon"),
                                                                              selectedImage: nil)
        
        self.viewControllers = [trackersViewCotrollerNavigationController, statisticsViewCotrollerNavigationController]
    }
}


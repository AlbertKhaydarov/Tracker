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
        
        navigationController.tabBarItem = UITabBarItem(title: "Трекеры",
                                                       image: UIImage(named: "trackersVCIcon"),
                                                       selectedImage: nil)
        
        let statisticsViewCotroller = StatisticsViewController()
        statisticsViewCotroller.tabBarItem = UITabBarItem(title: "Статистика",
                                                          image: UIImage(named: "statisticsVCIcon"),
                                                          selectedImage: nil)
        
        self.viewControllers = [navigationController, statisticsViewCotroller]
    }
}


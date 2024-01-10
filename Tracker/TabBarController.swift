//
//  ViewController.swift
//  Tracker
//
//  Created by Admin on 09.01.2024.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
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


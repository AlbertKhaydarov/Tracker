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
        view.backgroundColor = .YPWhite
        let trackersViewCotroller = TrackersViewController()
        trackersViewCotroller.tabBarItem = UITabBarItem(title: "Трекеры",
                                                         image: UIImage(named: "trackersVCIcon"),
                                                         selectedImage: nil)
        
        let statisticsViewCotroller = StatisticsViewController()
        statisticsViewCotroller.tabBarItem = UITabBarItem(title: "Статистика",
                                                          image: UIImage(named: "statisticsVCIcon"),
                                                          selectedImage: nil)
    }


}


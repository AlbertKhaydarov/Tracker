//
//  Router.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 31.01.2024.
//

import UIKit


final class ViewRouter: RouterProtocol  {
    
   init() {}
    
    func switchToViewController(from: UIViewController, to destimationVC: UIViewController, title: String) {
        destimationVC.title = title
        let navigationController = UINavigationController(rootViewController: destimationVC)
        from.present(navigationController, animated: true)
    }
}


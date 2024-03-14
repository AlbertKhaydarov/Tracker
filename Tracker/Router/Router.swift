//
//  Router.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 31.01.2024.
//

import UIKit


final class ViewRouter: RouterProtocol  {
    
    private var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController  = viewController
    }
    
    func switchToViewController(to destimationVC:UIViewController, title: String) {
        guard let fromViewController = self.viewController else {return}
        destimationVC.title = title
        let navigationController = UINavigationController(rootViewController: destimationVC)
        fromViewController.present(navigationController, animated: true)
    }
    
    func presentViewController(to destimationVC: UIViewController, title: String) {
        guard let fromViewController = self.viewController else {return}
        destimationVC.title = title
        fromViewController.present(destimationVC, animated: true)
    }
    
}


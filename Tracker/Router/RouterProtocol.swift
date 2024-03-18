//
//  RouterProtocol.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 31.01.2024.
//

import UIKit

protocol RouterProtocol {
    func switchToViewController(to destimationVC:UIViewController, title: String) 
    func presentViewController(to destimationVC:UIViewController, title: String)
}

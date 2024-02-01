//
//  RouterProtocol.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 31.01.2024.
//

import UIKit

protocol RouterProtocol {
    func switchToViewController(from: UIViewController, to destimationVC: UIViewController, title: String)
}
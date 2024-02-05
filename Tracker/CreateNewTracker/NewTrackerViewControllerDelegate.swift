//
//  NewTrackerViewControllerDelegate.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 01.02.2024.
//

import Foundation

protocol NewTrackerViewControllerDelegate: AnyObject {
    func addTimeSheet(_ weekDays: [Int])
}

//
//  TimeSheetViewControllerDelegate.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 13.03.2024.
//

import Foundation

protocol TimeSheetViewControllerDelegate: AnyObject {
    func getTimeSheetString(timeSheet: [Int]) -> String
}

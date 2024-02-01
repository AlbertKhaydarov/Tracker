//
//  TimeSheetCellDelegate.swift
//  Tracker
//
//  Created by Admin on 28.01.2024.
//

import Foundation

protocol TimeSheetCellDelegate: AnyObject {
    func getSwitchDay (for choosedWeekDay: Int)
}

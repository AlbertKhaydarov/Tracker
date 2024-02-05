//
//  TrackerCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 23.01.2024.
//

import Foundation

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func markCompletedTracker(id: UUID, indexPath: IndexPath, isCompleted: Bool)
}


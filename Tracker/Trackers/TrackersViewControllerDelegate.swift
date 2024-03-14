//
//  TrackerViewControllerDelegate.swift
//  Tracker
//
//  Created by Admin on 28.01.2024.
//

import Foundation

protocol TrackersViewControllerDelegate: AnyObject {
    func getNewTracker(_ newTracker: TrackerModel?, categoryName: String?)
    func deleteTracker(trackerId: UUID)
}



//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Альберт Хайдаров on 16.03.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    //MARK: - для проверки тестирования изменял collectionView.backgroundColor
    func testingLightThemeTrackersViewController() {
        let viewController = TrackersViewController()
        assertSnapshot(matching: viewController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testingDarkThemeTrackersViewController() {
        let viewController = TrackersViewController()
        
        assertSnapshot(matching: viewController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}


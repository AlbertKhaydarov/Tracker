//
//  TrackersCategoryStoreUpdate.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 09.02.2024.
//

import Foundation

struct TrackersCategoryStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

//
//  EmojiCollectionViewCellViewModel.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 28.02.2024.
//

import Foundation

final class EmojiCollectionViewCellViewModel {
    
    var selectedEmoji: String

    init( selectedEmoji: String) {
        self.selectedEmoji = selectedEmoji
    }
}

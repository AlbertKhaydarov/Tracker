//
//  CategoriesTypeTableViewCell.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 01.02.2024.
//

import UIKit

final class CategoriesTypeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
}


//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 11.01.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let trackerCellIdentifier = String(describing: TrackerCollectionViewCell.self)
    
    let trackerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackerLabel.clipsToBounds = true
        trackerLabel.layer.cornerRadius = 16
        contentView.addSubview(trackerLabel)
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        
       
       NSLayoutConstraint.activate([
        trackerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        trackerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

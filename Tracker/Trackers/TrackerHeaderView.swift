//
//  TrackerCollectionReusableView.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 11.01.2024.
//

import UIKit

final class TrackerHeaderView: UICollectionReusableView {
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .ypBold19
        label.textColor = .ypBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTrackerHeaderView()
    }
    
    private func setupTrackerHeaderView() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            //            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 11.01.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let trackerCellIdentifier = String(describing: TrackerCollectionViewCell.self)
    
    lazy var trackerBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .ypMedium12
        label.textColor = .ypWhite
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.backgroundColor = .clear
        contentView.addSubview(trackerBackgroundView)
        trackerBackgroundView.addSubview(trackerLabel)
    }
    
    
    private func setupCellLayout() {
        NSLayoutConstraint.activate([
            trackerBackgroundView.heightAnchor.constraint(equalToConstant: contentView.bounds.width),
            trackerBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            trackerLabel.leadingAnchor.constraint(equalTo: trackerBackgroundView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: trackerBackgroundView.trailingAnchor, constant: -12),
            trackerLabel.bottomAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: -12)
            ])
    }
    
}

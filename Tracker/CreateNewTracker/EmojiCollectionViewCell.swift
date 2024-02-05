//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 19.01.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    static let emojiCollectionViewCellIdentifier = String(describing: EmojiCollectionViewCell.self)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .ypBold32
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

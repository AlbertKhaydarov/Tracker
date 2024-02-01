//
//  ColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 19.01.2024.
//

import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell {
    static let colorsCollectionViewCellIdentifier = String(describing: ColorsCollectionViewCell.self)
    
    lazy var colorItemView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(colorItemView)
        
        NSLayoutConstraint.activate([
            colorItemView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorItemView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorItemView.heightAnchor.constraint(equalToConstant: 40),
            colorItemView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}

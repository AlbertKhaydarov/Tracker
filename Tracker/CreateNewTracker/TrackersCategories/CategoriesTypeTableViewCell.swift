//
//  CategoriesTypeTableViewCell.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 01.02.2024.
//

import UIKit

final class CategoriesTypeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var customSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        customSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setuplayout() {
        NSLayoutConstraint.activate([
            customSeparatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            customSeparatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            customSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customSeparatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configure(with sepatarorIsOn: Bool) {
        if sepatarorIsOn {
            contentView.addSubview(customSeparatorView)
            setuplayout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
}


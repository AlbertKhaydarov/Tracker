//
//  TimeSheetNewTrackerViewCell.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 28.02.2024.
//

import UIKit

final class TimeSheetNewTrackerViewCell: UITableViewCell {
    private lazy var customSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setuplayout() {
        customSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customSeparatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            customSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customSeparatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configureSeparator(with sepatarorIsOn: Bool) {
        if sepatarorIsOn {
            contentView.addSubview(customSeparatorView)
            setuplayout()
        }
    }
}

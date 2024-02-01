//
//  UIDatePicker+Extension.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 29.01.2024.
//

import UIKit

//MARK: - addCustomLabel to dataPicker
extension UIDatePicker {
    func addCustomLabel(text: String, width: CGFloat, height: CGFloat) {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: width, height: height)
        label.tag = 100
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

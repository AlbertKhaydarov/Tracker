//
//  TimeSheetTableViewCell.swift
//  Tracker
//
//  Created by Admin on 28.01.2024.
//

import UIKit

class TimeSheetTableViewCell: UITableViewCell {
        
        weak var delegateCell: TimeSheetCellDelegate?
        
        lazy var weekDay: UISwitch = {
            let weekDay = UISwitch()
            weekDay.translatesAutoresizingMaskIntoConstraints = false
            weekDay.onTintColor = .systemBlue
            weekDay.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
            return weekDay
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupCell()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: Selectors
        @objc
        private func switchTapped(_ sender: UISwitch) {
            if let weekDay = textLabel?.text {
                let day = shortDays(for: weekDay)
                delegateCell?.getSwitchDay(for: shortDays(for: day))
            }
        }
  
        private func shortDays(for weekDay: String) -> String {
            switch weekDay {
            case "Понедельник": return "Пн"
            case "Вторник": return "Вт"
            case "Среда": return "Ср"
            case "Четверг": return "Чт"
            case "Пятница": return "Пт"
            case "Суббота": return "Сб"
            case "Воскресенье": return "Вс"
            default: return ""
            }
        }
    
        func setupCell() {
            contentView.addSubview(weekDay)
            contentView.backgroundColor = .ypBackground.withAlphaComponent(0.3)
            
            NSLayoutConstraint.activate([
                weekDay.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
                weekDay.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            ])
        }
    }


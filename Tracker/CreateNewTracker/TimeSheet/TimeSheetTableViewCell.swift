//
//  TimeSheetTableViewCell.swift
//  Tracker
//
//  Created by Admin on 28.01.2024.
//

import UIKit

final class TimeSheetTableViewCell: UITableViewCell {
    
    weak var delegate: TimeSheetCellDelegate?
    
    private lazy var weekDayToogle: UISwitch = {
        let weekDay = UISwitch()
        weekDay.translatesAutoresizingMaskIntoConstraints = false
        weekDay.onTintColor = .systemBlue
        weekDay.addAction(UIAction(handler: { _ in
            self.weekDayToogleTapped()
        }), for: .valueChanged)
        return weekDay
    }()
    
    private var content:  UIListContentConfiguration!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with day: WeekDays) {
        content = defaultContentConfiguration()
        content.text = day.rawValue
        accessoryView = weekDayToogle
        contentConfiguration = content
        
    }
    
    private func weekDayToogleTapped() {
        if let weekDay = content.text {
            let day = "".shortDays(for: weekDay)
            delegate?.getSwitchDay(for: day)
        }
    }
    
    private func setupCell() {
        contentView.addSubview(weekDayToogle)
        contentView.backgroundColor = .ypBackground.withAlphaComponent(0.3)
        
        NSLayoutConstraint.activate([
            weekDayToogle.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            weekDayToogle.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}


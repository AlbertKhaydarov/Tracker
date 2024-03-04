//
//  TimeSheetTableViewCell.swift
//  Tracker
//
//  Created by Admin on 28.01.2024.
//

import UIKit

final class TimeSheetTableViewCell: UITableViewCell {
    
    weak var delegate: TimeSheetCellDelegate?
    
    lazy var weekDayToogle: UISwitch = {
        let weekDay = UISwitch()
        weekDay.onTintColor = .systemBlue
        weekDay.addTarget(self, action: #selector(weekDayToogleTapped), for: .touchUpInside)
        return weekDay
    }()
    
    private lazy var customSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with day: WeekDays, indexPath: IndexPath) {
        textLabel?.text = day.localizedString() /*day.rawValue*/
        accessoryView = weekDayToogle
    }
    
    private func setuplayout() {
        NSLayoutConstraint.activate([
            customSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customSeparatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            customSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customSeparatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configureSeparator(with sepatarorIsOn: Bool) {
        if sepatarorIsOn {
            contentView.addSubview(customSeparatorView)
            setuplayout()
        }
    }
    
    @objc private func weekDayToogleTapped(_ sender: UISwitch) {
        if let weekDay = textLabel?.text {
            let day = "".shortDays(for: weekDay)
            delegate?.getSwitchDay(for: day, toogleIsOn: sender.isOn)
        }
    }
    
    private func setupCell() {
        contentView.addSubview(weekDayToogle)
        customSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weekDayToogle.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            weekDayToogle.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}


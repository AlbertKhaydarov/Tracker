//
//  TimeSheetViewController.swift
//  Tracker
//
//  Created by Admin on 28.01.2024.
//

import UIKit

final class TimeSheetViewController: UIViewController {
    
    private var timeSheet: [Int] = []
    private var dataSource: UITableViewDiffableDataSource<Int, WeekDays>!
    private var storage: UserDefaultsStorageProtocol? = UserDefaultsStorage.shared
    private (set) var storageTimeSheet: [Int]? {
        get { return storage?.timeSheetStorage}
        set {storage?.timeSheetStorage = newValue}
    }
    
    weak var delegate: NewTrackerVCViewModelTimeSheetDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .ypWhite
        tableView.allowsSelection = false
        return tableView
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let readyButtonTitle = NSLocalizedString("readyButton.title", comment: "")
        button.setTitle(readyButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        view.addSubview(tableView)
        view.addSubview(readyButton)
        let timeSheetVCTitle = NSLocalizedString("timeSheetVC.title", comment: "")
        navigationItem.title  = timeSheetVCTitle
        setup()
        setupViews()
    }
    
    private func setup() {
        tableView.register(TimeSheetTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, day) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TimeSheetTableViewCell else {return UITableViewCell()}
            cell.configure(with: day, indexPath: indexPath)
            cell.backgroundColor = .ypBackground.withAlphaComponent(0.3)
            cell.delegate = self
            
            self.storageTimeSheet?.forEach{ dayNumber in
                if dayNumber == "".shortDays(for: day.localizedString()) {
                    cell.weekDayToogle.isOn = true
                    self.getSwitchDay(for: dayNumber, toogleIsOn: true)
                }
            }
            
            if indexPath.row == 0 {
                cell.configureSeparator(with: true)
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                cell.configureSeparator(with: false)
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.configureSeparator(with: true)
            }
            return cell
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, WeekDays>()
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(WeekDays.allCases)
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func setupViews(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: tableView.rowHeight * 7),
            
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func readyButtonTapped() {
        let timeSheetShortString = getTimeSheetString(timeSheet: timeSheet)
        delegate?.addTimeSheet(timeSheetShortString, timeSheet)
        dismiss(animated: true)
    }
    
    private func getTimeSheetShortString(timeSheet: [Int]?) -> String {
        var text: String = ""
        if let timeSheetShortString: [String] = timeSheet?.compactMap({ dayNumber in
            return "".weekdayFromInt(dayNumber)
        }) {
            let sortedDays = sortShortWeekdays(timeSheetShortString: timeSheetShortString)
            if sortedDays.count == 7 {
                let sortedDaysText = NSLocalizedString("sortedDaysText", comment: "")
                text = sortedDaysText
            } else {
                text = sortedDays.joined(separator: ", ")
            }
        }
        return text
    }
    
    //MARK: - sort short weekdays
    private func sortShortWeekdays(timeSheetShortString: [String]) -> [String] {
        let orderDay1 = NSLocalizedString("orderDay1", comment: "")
        let orderDay2 = NSLocalizedString("orderDay2", comment: "")
        let orderDay3 = NSLocalizedString("orderDay3", comment: "")
        let orderDay4 = NSLocalizedString("orderDay4", comment: "")
        let orderDay5 = NSLocalizedString("orderDay5", comment: "")
        let orderDay6 = NSLocalizedString("orderDay6", comment: "")
        let orderDay7 = NSLocalizedString("orderDay7", comment: "")
        
        let order =  [orderDay1: 0,
                      orderDay2: 1,
                      orderDay3: 2,
                      orderDay4: 3,
                      orderDay5: 4,
                      orderDay6: 5,
                      orderDay7: 6]
        let sortedDaysOfWeek = timeSheetShortString.sorted {
            guard let index1 = order[$0], let index2 = order[$1] else { return false }
            return index1 < index2
        }
        return sortedDaysOfWeek
    }
}

extension TimeSheetViewController: TimeSheetViewControllerProtocol{
    func getEditTimesheet(timeSheet: [Int]) {
        self.storageTimeSheet = timeSheet
    }
}

extension TimeSheetViewController: TimeSheetViewControllerDelegate {
    func getTimeSheetString(timeSheet: [Int]) -> String  {
        return getTimeSheetShortString(timeSheet: timeSheet)
    }
}

extension TimeSheetViewController: TimeSheetCellDelegate {
    func getSwitchDay (for choosedWeekDay: Int, toogleIsOn: Bool) {
        if toogleIsOn {
            if let existingTimeSheet = storage?.timeSheetStorage {
                timeSheet = existingTimeSheet
                if !timeSheet.contains(choosedWeekDay) {
                    timeSheet.append(choosedWeekDay)
                }
                self.storageTimeSheet = timeSheet
            }
        } else {
            timeSheet.removeAll { $0 == choosedWeekDay }
            self.storageTimeSheet = timeSheet
        }
    }
}

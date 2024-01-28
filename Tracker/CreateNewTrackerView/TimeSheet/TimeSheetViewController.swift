//
//  TimeSheetViewController.swift
//  Tracker
//
//  Created by Admin on 28.01.2024.
//

import UIKit

class TimeSheetViewController: UIViewController, TimetableCellDelegate {
 
    

    private var timeSheet: [String] = []
    private var dataSource: UITableViewDiffableDataSource<Int, WeekDays>!
  
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200), style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        return tableView
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(readyButton)
        navigationItem.title  = "Расписание"
        
        setup()
        setupViews()
    }
    
    private func setup() {
        tableView.register(TimeSheetTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, day) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TimeSheetTableViewCell else {return UITableViewCell()}
            cell.textLabel?.text = day.rawValue
            cell.delegateCell = self
            return cell
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, WeekDays>()
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(WeekDays.allCases)
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func setupViews(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: tableView.rowHeight * 8),
            
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    //MARK: - TBD
    @objc private func readyButtonTapped() {
        print(#function)
    }
}

extension TimeSheetViewController {
    func getSwitchDay (for day: String) {
        
    }
}

//
//  FiltersTypesViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 14.03.2024.
//

import UIKit

final class FiltersTypesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(FiltersTypesTableViewCell.self, forCellReuseIdentifier: FiltersTypesTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .ypWhite
        tableView.isScrollEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private (set) var lastSelectedFilter: Int? {
        get { return UserDefaultsStorage.shared.lastSelectedFilter}
        set {UserDefaultsStorage.shared.lastSelectedFilter = newValue ?? 0}
    }
    
    private var selectedFiltersTypes: FiltersTypes?
    
    weak var delegate: FiltersTypesViewControllerDelegate?
    
    init(selectedFiltersTypes: FiltersTypes) {
        self.selectedFiltersTypes = selectedFiltersTypes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupViews()
        setuplayout()
        updateLayout(with: self.view.frame.size)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setuplayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect(origin: .zero, size: size)
    }
}

extension FiltersTypesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FiltersTypes.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiltersTypesTableViewCell.reuseIdentifier, for: indexPath) as? FiltersTypesTableViewCell else {return UITableViewCell()}
        
        cell.textLabel?.text = FiltersTypes.allCases[indexPath.row].localizedString()
        cell.textLabel?.textColor = .ypBlack
        cell.textLabel?.font = .ypRegular17
        cell.backgroundColor = .ypBackground.withAlphaComponent(0.3)
        
        //MARK: - Set custom separator behavio
        
        if indexPath.row == 0 {
            cell.configure(with: true)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.configure(with: false)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.configure(with: true)
            cell.layer.cornerRadius = 0
            cell.layer.masksToBounds = true
        }
        
        if let lastSelectedFilter = lastSelectedFilter, indexPath.row == lastSelectedFilter {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

extension FiltersTypesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = .none
                lastSelectedFilter = indexPath.row
            }
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            delegate?.getFiltersType(self, selectedFilter: FiltersTypes.allCases[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
            dismiss(animated: true)
        }
    }
}

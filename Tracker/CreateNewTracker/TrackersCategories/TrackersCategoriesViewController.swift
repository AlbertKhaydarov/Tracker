//
//  EventCategoriesViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 31.01.2024.
//

import UIKit

final class TrackersCategoriesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(CategoriesTypeTableViewCell.self, forCellReuseIdentifier: CategoriesTypeTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .ypWhite
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Mock data
    private lazy var categoriesType: [Item] = {
        let data = [Item(name: "Домашний уют", isSelected: false),Item(name: "Радостные мелочи", isSelected: false), Item(name: "Учеба", isSelected: false), Item(name: "Радостные мелочи +", isSelected: false)]
        return data
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setuplayout()
        updateLayout(with: self.view.frame.size)
    }
    
    //MARK: - TBD
    @objc private func addCategoryButtonTapped() {
        print(#function)
    }
    
    private func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect(origin: .zero, size: size)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
    }
    
    private func setuplayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addCategoryButton.topAnchor.constraint(equalTo:  tableView.bottomAnchor),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}

extension TrackersCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesType.isEmpty ? 0 : categoriesType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTypeTableViewCell.reuseIdentifier, for: indexPath) as? CategoriesTypeTableViewCell else {return UITableViewCell()}
        
        let item = categoriesType[indexPath.row]
        cell.textLabel?.text = item.name
        cell.textLabel?.textColor = .ypBlack
        cell.textLabel?.font = .ypRegular17
        cell.backgroundColor = .ypBackground.withAlphaComponent(0.3)
        cell.accessoryType = item.isSelected ? .checkmark : .none
        
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
        }
        return cell
    }
}

extension TrackersCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //MARK: - move the element to the first row after selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = .none
            }
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
}

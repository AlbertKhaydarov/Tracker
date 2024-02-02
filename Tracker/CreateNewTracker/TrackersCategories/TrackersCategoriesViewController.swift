//
//  EventCategoriesViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 31.01.2024.
//

import UIKit

final class TrackersCategoriesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200), style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .ypGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(CategoriesTypeTableViewCell.self, forCellReuseIdentifier: CategoriesTypeTableViewCell.reuseIdentifier)
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = true
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
        let data = [Item(name: "Домашний уют", isSelected: false),Item(name: "Радостные мелочи", isSelected: false), Item(name: "Учеба", isSelected: false)]
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
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
        
        return cell
    }
}

extension TrackersCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //MARK: - move the element to the first row after selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            categoriesType[indexPath.row].isSelected = false
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            categoriesType[indexPath.row].isSelected = true
            let element = categoriesType[indexPath.row]
            categoriesType.remove(at: indexPath.row)
            categoriesType.insert(element, at: 0)
            
            tableView.beginUpdates()
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
}

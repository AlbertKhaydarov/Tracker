//
//  EventTypeViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 18.01.2024.
//

import UIKit

final class EventTypeViewController: UIViewController {
    
    weak var delegate: TrackersViewControllerDelegate?
    
    private lazy var habitTypeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Привычка", for: .normal)   
        button.titleLabel?.font = .ypMedium16
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addAction(UIAction(handler: { _ in
            self.creatNewHabit(titleTypeEvent: TypeEvents.habitType.rawValue)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var oneTimeTypeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Нерегулярное событие", for: .normal)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .ypMedium16
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addAction(UIAction(handler: { _ in
            self.creatNewHabit(titleTypeEvent: TypeEvents.oneTimeType.rawValue)
        }), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupViews()
        setupLayout()
    }
    
    private func creatNewHabit(titleTypeEvent: String) {
        let newHabitViewController = NewTrackerViewController()
        newHabitViewController.title = titleTypeEvent
        newHabitViewController.onTrackerCreated = { [weak self] tracker, category in
            guard let self = self else {return}
            self.delegate?.getNewTracker(tracker, categoryName: category)
        }
        
        let navigationController = UINavigationController(rootViewController: newHabitViewController)
        navigationController.navigationBar.barTintColor = .ypWhite
        present(navigationController, animated: true)
    }
    
    func setupViews() {
        view.addSubview(habitTypeButton)
        view.addSubview(oneTimeTypeButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            habitTypeButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            habitTypeButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            habitTypeButton.heightAnchor.constraint(equalToConstant: 60),
            habitTypeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitTypeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            oneTimeTypeButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            oneTimeTypeButton.topAnchor.constraint(equalTo: habitTypeButton.bottomAnchor, constant: 16),
            oneTimeTypeButton.heightAnchor.constraint(equalToConstant: 60),
            oneTimeTypeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            oneTimeTypeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}

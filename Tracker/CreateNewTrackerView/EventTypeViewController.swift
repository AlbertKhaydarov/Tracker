//
//  EventTypeViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 18.01.2024.
//

import UIKit

final class EventTypeViewController: UIViewController {
    
    weak var delegate: TrackerViewControllerDelegate?
    
    private lazy var habitTypeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Привычка", for: .normal)
        button.addTarget(self, action: #selector(addNewHabit), for: .touchUpInside)
        button.titleLabel?.font = .ypMedium16
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var oneTimeTypeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Нерегулярное событие", for: .normal)
        button.addTarget(self, action: #selector(addOneTimeEvent), for: .touchUpInside)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .ypMedium16
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupViews()
        setupLayout()
    }
    
    @objc
    private func addNewHabit() {
        creatNewHabit(titleTypeEvent: TypeEvents.habitType.rawValue, isHabbit: true)
        
       
    }
    
    @objc
    private func addOneTimeEvent() {
        creatNewHabit(titleTypeEvent: TypeEvents.oneTimeType.rawValue, isHabbit: false)

    }
    
    private func creatNewHabit(titleTypeEvent: String, isHabbit: Bool) {
        let newHabitViewController = NewTrackerViewController()
        newHabitViewController.title = titleTypeEvent
        newHabitViewController.onTrackerCreated = { [weak self] tracker, titleCategory in
            guard let self = self else {return}
            self.delegate?.getNewTracker(tracker, categoryName: titleCategory)
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

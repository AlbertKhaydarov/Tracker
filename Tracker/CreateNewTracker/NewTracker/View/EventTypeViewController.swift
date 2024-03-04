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
        let habitTypeButtonTitle = NSLocalizedString("habitTypeButton.title", comment: "")
        button.setTitle(habitTypeButtonTitle, for: .normal)
        button.titleLabel?.font = .ypMedium16
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(creatNewHabit(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var oneTimeTypeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let oneTimeTypeButtonTitle = NSLocalizedString("oneTimeTypeButton.title", comment: "")
        button.setTitle(oneTimeTypeButtonTitle, for: .normal)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .ypMedium16
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(creatNewHabit(_:)), for: .touchUpInside)
        return button
    }()
    
    private var viewRouter: RouterProtocol?
    private var storage: UserDefaultsStorageProtocol? = UserDefaultsStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        self.viewRouter = ViewRouter(viewController: self)
        setupViews()
        setupLayout()
    }
    
    private func createdNewTrackerWithEvent(newTracker: TrackerModel, category: String?, completion: (TrackerModel, String?) -> Void) {
        completion(newTracker, category)
    }
    
    @objc private func creatNewHabit(_ sender: UIButton) {
        let viewModel = NewTrackerVCViewModel()
        if sender == habitTypeButton {
            viewModel.typeEvent = TypeEvents.habitType

        } else if sender == oneTimeTypeButton {
            viewModel.typeEvent = TypeEvents.oneTimeType
        }
        
        let newHabitViewController = NewTrackerViewController(viewModel: viewModel)
        newHabitViewController.completionHandlerOnCreateButtonTapped = { [weak self] tracker, category in
            guard let self = self else {return}
            self.delegate?.getNewTracker(tracker, categoryName: category)
        }
        
        guard let viewRouter = viewRouter else {return}
        
        if viewModel.typeEvent == .habitType {
//            guard let typeEvent = viewModel.typeEvent?.rawValue else {return}
            guard let typeEvent = viewModel.typeEvent?.localizedString() else {return}
            viewRouter.switchToViewController(to: newHabitViewController, title: typeEvent)
            storage?.timeSheetStorage = []
        } else if viewModel.typeEvent == .oneTimeType {
            guard let typeEvent = viewModel.typeEvent?.localizedString() else {return}
            viewRouter.switchToViewController(to: newHabitViewController, title: typeEvent)
            print(typeEvent)
        } else {
            return
        }
    }
    
    private func setupViews() {
        view.addSubview(habitTypeButton)
        view.addSubview(oneTimeTypeButton)
    }
    
    private func setupLayout() {
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

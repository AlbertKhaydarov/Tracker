//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 19.01.2024.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    
    private let colorSelection: [UIColor] = UIColor.colorSelection
    private let emojiesCollection: [String] = String.emojiesCollection
    private var timeSheetWeekDays: [Int]?
    private var categoryTitle: String = "здесь будут выбранные категории"
    
    //MARK: - to redifine after completed all tracker cases
    private var nameTracker = false
    private var timeSheetIsEnable = false
    private var categoryIsEnable = false
    
    private let titlesButtons: [String] = ["Категория", "Расписание"]
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .ypWhite
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let contentViewForScrollView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private lazy var nameInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        textField.leftViewMode = .always
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .ypBackground.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.clipsToBounds = true
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private let lengthLimitationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .ypRed
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        stackView.addArrangedSubview(nameInputTextField)
        stackView.addArrangedSubview(lengthLimitationLabel)
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .ypGray
        tableView.backgroundColor = .ypWhite
        tableView.register(NewTrackerViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()

        return tableView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiCollectionViewCell.self,
                                forCellWithReuseIdentifier: EmojiCollectionViewCell.emojiCollectionViewCellIdentifier)
        collectionView.register(ColorsCollectionViewCell.self,
                                forCellWithReuseIdentifier: ColorsCollectionViewCell.colorsCollectionViewCellIdentifier)
        collectionView.register(TrackerHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .ypWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var tableViewHeightConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    private lazy var collectionViewHeightConstraint: NSLayoutConstraint = {
        collectionView.heightAnchor.constraint(equalToConstant: 0)
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.setTitleColor(.ypRed, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancelButtontapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    var completionHandlerOnCreateButtonTapped: ((_ newTracker: TrackerModel, _ nameCategory: String?) -> Void)?
    private var viewRouter: RouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        scrollView.delegate = self
        setupViews()
        setupLayout()
        setupTableViewAndCollectionViewHeight()
        
        self.viewRouter = ViewRouter()
    }
    
   @objc private func createButtonTapped() {
       //MARK: - Mock category, to be define in categoryTitle
       let category = "1"
        
        guard let text = nameInputTextField.text else { return }
        var newTracker: TrackerModel
        if let typeEvent = TypeEvents(rawValue: self.title ?? "") {
            switch typeEvent {
            case .habitType:
                guard let timeSheet = timeSheetWeekDays else {return}
                newTracker = TrackerModel(id: UUID(), name: text, color: .blue, emoji: .emojiesCollection.first ?? "🙂", timesheet: timeSheet)
                completionHandlerOnCreateButtonTapped?(newTracker, category)
                
            case .oneTimeType:
                newTracker = TrackerModel(id: UUID(), name: text, color: .blue, emoji: .emojiesCollection.first ?? "🏓", timesheet: [])
                completionHandlerOnCreateButtonTapped?(newTracker, category)
            }
        } else {
            print("Ошибка создания трекера")
            return
        }
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
   @objc private func cancelButtontapped() {
        dismiss(animated: true)
    }
    
    //MARK: - add others check up
    private func createButtonIsEnabled() {
        if nameTracker && timeSheetIsEnable && categoryIsEnable {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentViewForScrollView)
        contentViewForScrollView.addSubview(textFieldStackView)
        contentViewForScrollView.addSubview(tableView)
        contentViewForScrollView.addSubview(collectionView)
        contentViewForScrollView.addSubview(buttonsStackView)
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentViewForScrollView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            contentViewForScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentViewForScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentViewForScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentViewForScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            textFieldStackView.topAnchor.constraint(equalTo: contentViewForScrollView.topAnchor, constant: 24),
            textFieldStackView.leadingAnchor.constraint(equalTo: contentViewForScrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentViewForScrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            nameInputTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentViewForScrollView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentViewForScrollView.trailingAnchor, constant: -16),
            tableViewHeightConstraint,
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentViewForScrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentViewForScrollView.trailingAnchor),
            collectionViewHeightConstraint,
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentViewForScrollView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentViewForScrollView.trailingAnchor, constant:  -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentViewForScrollView.bottomAnchor, constant: -15)
        ])
        if lengthLimitationLabel.isHidden == false {
            setupLengthLimitationLabelConstraints()
        }
    }
    
    private func setupTableViewAndCollectionViewHeight() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
        return
    }
    
    private func setupLengthLimitationLabelConstraints() {
        NSLayoutConstraint.activate([
            lengthLimitationLabel.topAnchor.constraint(equalTo: nameInputTextField.bottomAnchor, constant: 8),
            lengthLimitationLabel.centerXAnchor.constraint(equalTo: textFieldStackView.centerXAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension NewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? emojiesCollection.count : colorSelection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.emojiCollectionViewCellIdentifier, for: indexPath
            ) as? EmojiCollectionViewCell else { return UICollectionViewCell()}
            
            cell.titleLabel.text = emojiesCollection[indexPath.row]
            cell.backgroundColor = cell.isSelected ? .ypBackground : .clear
            
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorsCollectionViewCell.colorsCollectionViewCellIdentifier, for: indexPath
            ) as? ColorsCollectionViewCell else { return UICollectionViewCell()}
            
            cell.sizeToFit()
            cell.colorItemView.backgroundColor = colorSelection[indexPath.row]
            
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UIScrollViewDelegate
extension NewTrackerViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
// MARK: - UICollectionViewDelegate
extension NewTrackerViewController: UICollectionViewDelegate & UICollectionViewDelegateFlowLayout {
   
    //MARK: - TBD
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 19)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = "default"
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerHeaderView else {
            return UICollectionReusableView()
        }
        
        view.titleLabel.text = indexPath.section == 0 ? "Emoji" : "Цвет"
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - UITextFieldDelegate
extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        nameTracker = true
        createButtonIsEnabled()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        lengthLimitationLabel.isHidden = true
        setupLayout()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        let inputText = textField.text ?? ""
        guard let rangeTextSymbols = Range(range, in: inputText) else { return false }
        let updatedText = inputText.replacingCharacters(in: rangeTextSymbols, with: string)
        
        if updatedText.count >= maxLength {
            lengthLimitationLabel.isHidden = false
            setupLengthLimitationLabelConstraints()
        } else {
            lengthLimitationLabel.isHidden = true
            setupLayout()
        }
        if updatedText.count != 0 {
            nameTracker = true
        }
        createButtonIsEnabled()
        return updatedText.count <= maxLength
    }
}

//MARK: - UITableViewDataSource
extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsInSection = 2
        if let typeEvent = TypeEvents(rawValue: self.title ?? "") {
            switch typeEvent {
            case .habitType:
                rowsInSection = 2
                tableViewHeightConstraint.constant = 150
            case .oneTimeType:
                rowsInSection = 1
                tableViewHeightConstraint.constant = 75
                timeSheetIsEnable = true
                tableView.separatorStyle = .none
                createButtonIsEnabled()
            }
        }
        return rowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath) as? NewTrackerViewCell else {return UITableViewCell()}

        cell.textLabel?.text = titlesButtons[indexPath.row]
        cell.textLabel?.textColor = .ypBlack
        cell.textLabel?.font = .ypRegular17
        
        //MARK: - TBD
        switch indexPath.row {
        case  0:
            cell.detailTextLabel?.text = categoryTitle
            categoryIsEnable = true
        case  1:
            if let timeSheetShortString: [String] = timeSheetWeekDays?.compactMap({ dayNumber in
                return "".weekdayFromInt(dayNumber)
            }) {
                cell.detailTextLabel?.text = timeSheetShortString.joined(separator: ", ")
                if timeSheetShortString.isEmpty {
                    timeSheetIsEnable = false
                } else {
                    timeSheetIsEnable = true
                }
            }
        default:
            break
        }
        
        cell.detailTextLabel?.textColor = .ypGray
        cell.detailTextLabel?.font  = .ypRegular17
        cell.backgroundColor = .ypBackground.withAlphaComponent(0.3)
        cell.accessoryType = .disclosureIndicator

        createButtonIsEnabled()
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismissKeyboard()
        switch indexPath.row {
            //MARK: - TBD
        case 0: let viewController = TrackersCategoriesViewController()
            if let viewRouter = viewRouter {
                viewRouter.switchToViewController(from: self, to: viewController, title: "Категория")
            }
        case 1: let viewController = TimeSheetViewController()
            if let viewRouter = viewRouter {
                viewRouter.switchToViewController(from: self, to: viewController, title: "Расписание")
                viewController.delegate = self
            }
        default: break
        }
    }
}

//MARK: - UITableViewDelegate
extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 1  {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

//MARK: - NewTrackerViewControllerDelegate
extension NewTrackerViewController: NewTrackerViewControllerDelegate {
    func addTimeSheet(_ weekDays: [Int]) {
        timeSheetWeekDays = weekDays
        tableView.reloadData()
    }
}

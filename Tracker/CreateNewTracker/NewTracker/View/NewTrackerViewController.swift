//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 19.01.2024.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    private let colorSelection: [UIColor] = UIColor.colorSelection
//    private let emojiesCollection: [String] = String.emojiesCollection
    private var categoryTitle: String = "здесь будут выбранные категории"
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
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhite
        tableView.register(CategoryNewTrackerViewCell.self, forCellReuseIdentifier: "categoryCellReuseIdentifier")
        tableView.register(TimeSheetNewTrackerViewCell.self, forCellReuseIdentifier: "timeSheetCellReuseIdentifier")
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
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
    
//    private var indexPathForSelectedEmoji: IndexPath?
//    private var indexPathForSelectedColor: IndexPath?
//    
//    private var nameTracker = false
//    private var timeSheetIsEnable = false
//    private var categoryIsEnable = false
//    private var emojiSelectedIsEnable = false
//    private var colorSelectedIsEnable = false
    
    private var viewRouter: RouterProtocol?
    
    var viewModel: NewTrackerVCViewModel?
    
    init(viewModel: NewTrackerVCViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        scrollView.delegate = self
        setupViews()
        setupLayout()
        setupTableViewAndCollectionViewHeight()
        self.viewRouter = ViewRouter(viewController: self)

        if let viewModel = viewModel {
            bind(viewModel: viewModel)
        }
    }
    
    //MARK: - add binding
    private func bind(viewModel: NewTrackerVCViewModel) {
        viewModel.selectedCategory.bind { [weak self] _ in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
        viewModel.weekDays.bind { [weak self] _ in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
    }
    
    @objc private func createButtonTapped() {
        guard let text = nameInputTextField.text,
              let category = viewModel?.selectedCategory.value?.selectedCategory
        else { return }
        
        var newTracker: TrackerModel
        if let typeEvent = TypeEvents(rawValue: self.title ?? "") {
            guard let emoji = viewModel?.selectedEmoji.value?.selectedEmoji,
                  let color = viewModel?.selectedColor.value?.selectedColors
            else {return}
            switch typeEvent {
            case .habitType:
                guard let timeSheet = viewModel?.weekDays.value?.weekdays else {return}
                newTracker = TrackerModel(idTracker: UUID(),
                                          name: text,
                                          color: color,
                                          emoji: emoji,
                                          timesheet: timeSheet)
                self.completionHandlerOnCreateButtonTapped?(newTracker, category)
            case .oneTimeType:
                newTracker = TrackerModel(idTracker: UUID(),
                                          name: text,
                                          color: color,
                                          emoji: emoji,
                                          timesheet: [])
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
        guard let viewModel = viewModel else {return}
        if viewModel.isTrackerNameEmpty && viewModel.timeSheetIsEnable && viewModel.categoryIsEnable && viewModel.emojiSelectedIsEnable && viewModel.colorSelectedIsEnable {
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
    
    //MARK: - Handle selection in CollectionView
    private func handleEmojiSelection(at indexPath: IndexPath) {
        if let selectedIndexPath = viewModel?.indexPathForSelectedEmoji, let cell = collectionView.cellForItem(at: selectedIndexPath) {
            clearSelection(for: cell, at: selectedIndexPath)
        }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        viewModel?.handleEmojiSelection(at: indexPath)
        selectCell(cell, at: indexPath,
                     withColor: .ypLightGray,
                     cornerRadius: 16)
        createButtonIsEnabled()
    }
    
    private func handleColorSelection(at indexPath: IndexPath) {
        if let selectedIndexPath = viewModel?.indexPathForSelectedColor, let cell = collectionView.cellForItem(at: selectedIndexPath) {
            clearSelection(for: cell, at: selectedIndexPath)
        }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        viewModel?.handleColorSelection(at: indexPath)
        selectCell(cell, at: indexPath,
                     withColor: colorSelection[indexPath.row].withAlphaComponent(0.3),
                     cornerRadius: 8,
                     borderWidth: 3)
        createButtonIsEnabled()
    }
    
    private func clearSelection(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.layer.borderWidth = 0
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    private func selectCell(_ cell: UICollectionViewCell, at indexPath: IndexPath, withColor color: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat = 0) {
        cell.backgroundColor = color
        cell.layer.cornerRadius = cornerRadius
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = borderWidth
        cell.layer.borderColor = color.cgColor
    }
    
    //MARK: - setup Views and Layouts
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

// MARK: - UIScrollViewDelegate
extension NewTrackerViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel?.isTrackerNameEmpty = true
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
            viewModel?.isTrackerNameEmpty = true
        }
        createButtonIsEnabled()
        return updatedText.count <= maxLength
    }
}

//MARK: - UITableViewDataSource
extension NewTrackerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsInSection = 0
        if let typeEvent = TypeEvents(rawValue: self.title ?? "") {
            switch typeEvent {
            case .habitType:
                if section == 0 {
                    rowsInSection = 1
                } else if section == 1 {
                    rowsInSection = 1
                }
                tableViewHeightConstraint.constant = 150
            case .oneTimeType:
                rowsInSection = 1
                tableViewHeightConstraint.constant = 75
                viewModel?.timeSheetIsEnable = true
                tableView.separatorStyle = .none
                createButtonIsEnabled()
            }
        }
        return rowsInSection
    }
    
    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.text = titlesButtons[indexPath.section]
        cell.textLabel?.textColor = .ypBlack
        cell.textLabel?.font = .ypRegular17
        cell.detailTextLabel?.textColor = .ypGray
        cell.detailTextLabel?.font  = .ypRegular17
        cell.backgroundColor = .ypBackground.withAlphaComponent(0.3)
        cell.accessoryType = .disclosureIndicator
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let typeEvent = TypeEvents(rawValue: self.title ?? "") {
            switch typeEvent {
            case .habitType:
                if indexPath.section == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCellReuseIdentifier", for: indexPath) as? CategoryNewTrackerViewCell else {return UITableViewCell()}
                    configureCell(cell: cell, indexPath: indexPath)
                    if let viewModel = viewModel {
                        let selectedCategory = viewModel.selectedCategory.value?.selectedCategory
                        cell.detailTextLabel?.text = selectedCategory
                    }
                    viewModel?.categoryIsEnable = true
                    createButtonIsEnabled()
                    return cell
                } else if indexPath.section == 1 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "timeSheetCellReuseIdentifier", for: indexPath) as? TimeSheetNewTrackerViewCell else {return UITableViewCell()}
                    configureCell(cell: cell, indexPath: indexPath)
                    
                    if let timeSheetDays = viewModel?.weekDays.value?.weekdays
                    {
                        if timeSheetDays.count == 7 {
                            cell.detailTextLabel?.text = "Каждый день"
                        } else {
                            cell.detailTextLabel?.text = viewModel?.weekDays.value?.timeSheetDays
                        }
                        if timeSheetDays.isEmpty {
                            viewModel?.timeSheetIsEnable = false
                        } else {
                            viewModel?.timeSheetIsEnable = true
                        }
                    }
                    cell.configureSeparator(with: true)
                    viewModel?.categoryIsEnable = true
                    createButtonIsEnabled()
                    return cell
                }
            case .oneTimeType:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCellReuseIdentifier", for: indexPath) as? CategoryNewTrackerViewCell else {return UITableViewCell()}
                configureCell(cell: cell, indexPath: indexPath)
                if let viewModel = viewModel {
                    let selectedCategory = viewModel.selectedCategory.value?.selectedCategory
                    cell.detailTextLabel?.text = selectedCategory
                }
                viewModel?.categoryIsEnable = true
                createButtonIsEnabled()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismissKeyboard()
        
        if indexPath.section == 0{
            let categoryTypeVCViewModel = CategoryTypeVCViewModel()
            let viewController = CategoriesTypeViewController(viewModel: categoryTypeVCViewModel)
            if let viewRouter = viewRouter {
                viewRouter.switchToViewController(to: viewController, title: "Категория")
                viewController.delegate = viewModel
            }
        } else {
            let viewController = TimeSheetViewController()
            if let viewRouter = viewRouter {
                viewRouter.switchToViewController(to: viewController, title: "Расписание")
                viewController.delegate = viewModel
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}

// MARK: - UICollectionViewDataSource
extension NewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {return 0}
        return section == 0 ? viewModel.emojiesCollection.count :  viewModel.colorSelection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.emojiCollectionViewCellIdentifier, for: indexPath
            ) as? EmojiCollectionViewCell else { return UICollectionViewCell()}
            
            cell.titleLabel.text =  viewModel?.emojiesCollection[indexPath.row]
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

// MARK: UICollectionViewDelegateFlowLayout
extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - UICollectionViewDelegate
extension NewTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissKeyboard()
        if indexPath.section == 0 {
            handleEmojiSelection(at: indexPath)
        } else if indexPath.section == 1 {
            handleColorSelection(at: indexPath)
        }
    }
}
//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 19.01.2024.
//

import UIKit

final class NewHabitViewController: UIViewController {
    
    private let colorSelection: [UIColor] = UIColor.colorSelection
    private let emojiesCollection: [String] = String.emojiesCollection
    
//    private var collectionViewHeightContraint: NSLayoutConstraint!
 
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
    
    private let SymbolsLimitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ограничение 38 символов"
        label.font = .ypRegular17
        label.textColor = .ypRed
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isHidden = true
        return label
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
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.addArrangedSubview(nameInputTextField)
        stackView.addArrangedSubview(lengthLimitationLabel)
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
//            frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 150),
//                                    style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .ypGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.reloadData()
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

        collectionView.backgroundColor = .ypWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
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
//        button.addTarget(self, action: #selector(cancelButtontapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        scrollView.delegate = self
        setupViews()
        setupLayout()
        setupCollectionViewHeight()
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentViewForScrollView)
      
        contentViewForScrollView.addSubview(textFieldStackView)
        contentViewForScrollView.addSubview(tableView)
        contentViewForScrollView.addSubview(collectionView)
        contentViewForScrollView.addSubview(buttonsStackView)
        
//        collectionViewHeightContraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    func setupLayout() {
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
            
            nameInputTextField.heightAnchor.constraint(equalToConstant: 75),
            nameInputTextField.topAnchor.constraint(equalTo: contentViewForScrollView.topAnchor, constant: 24),
            nameInputTextField.leadingAnchor.constraint(equalTo: contentViewForScrollView.leadingAnchor, constant: 16),
            nameInputTextField.trailingAnchor.constraint(equalTo: contentViewForScrollView.trailingAnchor, constant: -16),
            
            textFieldStackView.topAnchor.constraint(equalTo: contentViewForScrollView.topAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: contentViewForScrollView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentViewForScrollView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.topAnchor.constraint(equalTo: nameInputTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentViewForScrollView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentViewForScrollView.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentViewForScrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentViewForScrollView.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 480),
// collectionViewHeightContraint,
           
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentViewForScrollView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentViewForScrollView.trailingAnchor, constant:  -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentViewForScrollView.bottomAnchor, constant: -15)
        ])
    }
    
    func setupCollectionViewHeight() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
//        collectionViewHeightContraint.constant = collectionView.contentSize.height
    }
}

// MARK: - UICollectionViewDataSource
extension NewHabitViewController: UICollectionViewDataSource {
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
extension NewHabitViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
// MARK: - UICollectionViewDelegate
extension NewHabitViewController: UICollectionViewDelegate & UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        dismissKeyboard()
//        if indexPath.section == 0 {
//            if let selectedCell = isSelectedEmoji, let cell = collectionView.cellForItem(at: selectedCell) {
//                cell.backgroundColor = .clear
//                collectionView.deselectItem(at: selectedCell, animated: true)
//            }
//            let cell = collectionView.cellForItem(at: indexPath)
//            cell?.layer.cornerRadius = 16
//            cell?.backgroundColor = .yp_LightGray
//            isSelectedEmoji = indexPath
//            isEnabledDictionary["emoji"] = true
//            createButtonIsEnabled()
//        } else if indexPath.section == 1 {
//            if let selectedCell = isSelectedColor, let cell = collectionView.cellForItem(at: selectedCell) {
//                cell.layer.borderWidth = 0
//                collectionView.deselectItem(at: selectedCell, animated: true)
//            }
//            let cell = collectionView.cellForItem(at: indexPath)
//            cell?.layer.cornerRadius = 8
//            cell?.layer.borderWidth = 3
//            cell?.layer.borderColor = UIColor.colorSelection[indexPath.row].withAlphaComponent(0.3).cgColor
//            isSelectedColor = indexPath
//            isEnabledDictionary["colour"] = true
//            createButtonIsEnabled()
//        }
//    }
    
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
        
//        if indexPath.section == 0 {
//            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerHeaderView else { return UICollectionReusableView()}
//            view.titleLabel.text = "Emoji"
//            return view
//        } else {
//            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerHeaderView else { return UICollectionReusableView()}
//            view.titleLabel.text = "Цвет"
//            return view
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

extension NewHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titlesButtons[indexPath.row]
        cell.backgroundColor = .ypBackground.withAlphaComponent(0.3)
        cell.accessoryType = .disclosureIndicator
        
        
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismissKeyboard()
        switch indexPath.row {
            //MARK: - TBD
        case 0: let viewController = UIViewController()
            
        case 1: let viewController = TimeSheetViewController()
            show(viewController, "Расписание")

        default: break
        }
    }
        private func show(_ viewController: UIViewController, _ title: String) {
            let viewController = viewController
            viewController.title = title
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true)
        }
    
    
    
}
extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    
}

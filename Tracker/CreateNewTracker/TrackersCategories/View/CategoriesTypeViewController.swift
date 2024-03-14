//
//  EventCategoriesViewController.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 31.01.2024.
//

import UIKit

final class CategoriesTypeViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(CategoriesTypeTableViewCell.self, forCellReuseIdentifier: CategoriesTypeTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .ypWhite
        tableView.isScrollEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let addCategoryButtonTitle = NSLocalizedString("addCategoryButton.title", comment: "")
        button.setTitle(addCategoryButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private (set) var lastSelectedcategory: Int? {
        get { return UserDefaultsStorage.shared.lastSelectedcategory}
        set {UserDefaultsStorage.shared.lastSelectedcategory = newValue ?? 0}
    }
    
    //MARK: - add Stub Scene Logo
    private lazy var errorTrackersLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "errorTrackersLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var errorTrackersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let errorTrackersLabelTitle = NSLocalizedString("errorTrackersLabel.title", comment: "")
        label.text = errorTrackersLabelTitle
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var notCreatedLogoStackView: UIStackView = {
        let vStackView = UIStackView(arrangedSubviews: [errorTrackersLogo, errorTrackersLabel])
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.axis = .vertical
        vStackView.spacing = 8
        return vStackView
    }()
    
    weak var delegate: NewTrackerVCViewModelCategoryTypeDelegate?
    private var viewModel: CategoryTypeVCViewModel?
    private var viewRouter: RouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        if let viewModel = viewModel {
            bind(viewModel: viewModel)
        }
        
        self.viewRouter = ViewRouter(viewController: self)
        let categoriesVCTitle = NSLocalizedString("categoriesVC.title", comment: "")
        title = categoriesVCTitle
        setupViews()
        setuplayout()
        updateLayout(with: self.view.frame.size)
        showNotCreatedStub()
    }
    
    init(viewModel: CategoryTypeVCViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - add binding
    private func bind(viewModel: CategoryTypeVCViewModel) {
        viewModel.categotyTypesBinding = { [weak self] _ in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
        viewModel.categoryForEditObservable.bind { [weak self] categoryType in
            guard let self = self,
            let categoryType = categoryType
            else {return}
            self.edit(categoryType: categoryType)
        }
    }
    
    private func edit(categoryType: String) {
       
        let editCategoryTypeViewController = NewCategoryTypeViewController()
        editCategoryTypeViewController.edit(categoryType: categoryType)
        editCategoryTypeViewController.delegate = viewModel
        let editCategoryTypeTitle = NSLocalizedString("editCategoryType.title", comment: "")
        if let viewRouter = viewRouter {
                viewRouter.switchToViewController(to: editCategoryTypeViewController, title: editCategoryTypeTitle)
            }
    }
    
    private func showNotCreatedStub() {
        if viewModel?.categoryType.count == 0 {
            addNotCreatedLogo()
            notCreatedLogoStackView.isHidden = false
        }
    }
    
    //MARK: - setup Stub image
    private func addNotCreatedLogo() {
        view.addSubview(notCreatedLogoStackView)
        setupErrorLogoLayout()
    }
    
    private func setupErrorLogoLayout() {
        NSLayoutConstraint.activate([
            notCreatedLogoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notCreatedLogoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        )
    }
    
    @objc private func addCategoryButtonTapped() {
        let newCategoryTypeVCTitle = NSLocalizedString("newCategoryTypeVC.title", comment: "")
        let newCategoryTypeViewController = NewCategoryTypeViewController()
        newCategoryTypeViewController.delegate = viewModel
        if let viewRouter = viewRouter {
            viewRouter.switchToViewController(to: newCategoryTypeViewController, title: newCategoryTypeVCTitle)
        }
        
//        switchToNewCategoryTypeViewController(categoryTitle: newCategoryTypeVCTitle)
    }
    
//    private func switchToNewCategoryTypeViewController(categoryTitle: String?){
//        let newCategoryTypeViewController = NewCategoryTypeViewController()
//        newCategoryTypeViewController.delegate = viewModel
//        if let viewRouter = viewRouter {
//            guard let categoryTitle = categoryTitle else {return}
//            viewRouter.switchToViewController(to: newCategoryTypeViewController, title: categoryTitle)
//        }
//    }
    
    
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

extension CategoriesTypeViewController: CategoriesTypeViewControllerProtocol {
func getEditCategory(category: String) -> IndexPath? {
    if let selectedCategoryTypeIndex = viewModel?.categoryType.firstIndex(where: { $0.categoryTitle == category }) {
        return IndexPath(row: selectedCategoryTypeIndex, section: 0)
    }
    return nil
}
}

extension CategoriesTypeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.categoryType.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTypeTableViewCell.reuseIdentifier, for: indexPath) as? CategoriesTypeTableViewCell else {return UITableViewCell()}
        
        cell.viewModel = viewModel?.categoryType[indexPath.row]
        cell.textLabel?.textColor = .ypBlack
        cell.textLabel?.font = .ypRegular17
        cell.backgroundColor = .ypBackground.withAlphaComponent(0.3)
        
        //MARK: - Set custom separator behavior
        let count = viewModel?.categoryType.count ?? 0
        if count != 0 {
            notCreatedLogoStackView.isHidden = true
        }
        
        if count > 1 {
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
        } else {
            cell.configure(with: false)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            
        }
        
        if let lastSelectedcategory = lastSelectedcategory, indexPath.row == lastSelectedcategory {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

extension CategoriesTypeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //MARK: - move the element to the first row after selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = .none
                lastSelectedcategory = indexPath.row
            }
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            guard let viewModel = viewModel?.categoryType[indexPath.row] else {return}
            handleCategoryTypeSelection(categoryTypeCellViewModel: viewModel)
            tableView.deselectRow(at: indexPath, animated: true)
            dismiss(animated: true)
        }
    }
    
    //MARK: - Handle selection Category Type
    private func handleCategoryTypeSelection(categoryTypeCellViewModel: CategoryTypeCellViewModel) {
        categoryTypeCellViewModel.categoryTitleBinding = {[weak self] category in
            guard let self = self else {return}
            self.delegate?.getSelectedCategoryType(category)
        }
    }
    
    //MARK: - Context Menu
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
       
        return UIContextMenuConfiguration(actionProvider: { [weak self] actions in
            let editAction = NSLocalizedString("editAction.title", comment: "")
            let deleteAction = NSLocalizedString("deleteAction.title", comment: "")
            return UIMenu(children: [
                UIAction(title: editAction) { [weak self] _ in
                    guard let self else { return }
                    self.editCategoryType(indexPath: indexPath)
                },
                UIAction(title: deleteAction, attributes: .destructive) { _ in
                    guard let self else { return }
                    self.showDeleteAlert(with: indexPath)
                   
                }
            ])
        })
    }
    
    private func editCategoryType(indexPath: IndexPath) {
        if let categoryType = viewModel?.categoryType[indexPath.row].categoryTitle {
            viewModel?.deleteCategorytype(with: indexPath)
            viewModel?.edit(categoryType: categoryType)
        }
    }
    // MARK: - Alert Controller
    private func showDeleteAlert(with indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: NSLocalizedString("alertControllerCategoryTypeDeleteConfirm.title", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(
            title: NSLocalizedString("deleteButton.title", comment: ""),
            style: .destructive
        ) { [weak self] _ in
            guard let self else { return }
            self.viewModel?.deleteCategorytype(with: indexPath)
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("cancelButton.title", comment: ""), style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

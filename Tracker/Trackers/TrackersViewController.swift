//
//  TrackersViewControllers.swift
//  Tracker
//
//  Created by Admin on 09.01.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    private var pinTracker = false
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var displayedTrackers: [TrackerCategory] = []
    private var pinnedTrackers: [TrackerModel] = []
    
    //MARK: - add CoreData Stores
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var searchController: UISearchController?
    private var currentDate: String = ""
    private var isCompleted: Bool = false
    
    
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
        let errorTrackersLabelText = NSLocalizedString("errorTrackersLabel.titleText", comment: "")
        label.text = errorTrackersLabelText
        label.font = .ypMedium12
        return label
    }()
    
    private lazy var notCreatedLogoStackView: UIStackView = {
        let vStackView = UIStackView(arrangedSubviews: [errorTrackersLogo, errorTrackersLabel])
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.axis = .vertical
        vStackView.spacing = 8
        return vStackView
    }()
    
    private lazy var notFoundTrackersLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "notFoundLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var notFoundTrackersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let notFoundTrackersLabelText = NSLocalizedString("notFoundTrackersLabelText", comment: "")
        label.text = notFoundTrackersLabelText
        label.font = .ypMedium12
        return label
    }()
    
    private lazy var notFoundLogoStackView: UIStackView = {
        let vStackView = UIStackView(arrangedSubviews: [notFoundTrackersLogo, notFoundTrackersLabel])
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.axis = .vertical
        vStackView.spacing = 8
        return vStackView
    }()
    
    private let params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9, lineSpacingForSectionAt: 16, lineSpacingForHeaderAndCard: 12)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.trackerCellIdentifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        //        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.locale = Locale.current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private var viewRouter: RouterProtocol?
    
    weak var delegate: TimeSheetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCategories()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.backgroundColor = .ypWhite
        let trackersVCTitleText = NSLocalizedString("trackersVCTitleText", comment: "")
        title = trackersVCTitleText
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        self.viewRouter = ViewRouter(viewController: self)
        
        getCompletedTrackers()
        
        setupCustomDatePickerView(with: Date())
        addNavButton()
        setup()
        setupSearchController()
        showNotCreatedStub()
    }
    
    private func getCompletedTrackers() {
        do {
            completedTrackers = try trackerRecordStore.getTrackersRecords()
        } catch {
            assertionFailure("Failed to create \(String(describing: CoreDataErrors.decodingError(error)))", file: #file, line: #line)
        }
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController?.searchBar.placeholder = "Поиск"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypBlack,
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        let searchBarButtonTitle = NSLocalizedString("searchBarButton.title", comment: "")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = searchBarButtonTitle
    }
    
    private func showNotCreatedStub() {
        if displayedTrackers.isEmpty {
            addNotCreatedLogo()
            notCreatedLogoStackView.isHidden = false
        }
    }
    
    private func showNotFoundStub() {
        if displayedTrackers.isEmpty {
            addNotFoundLogo()
            notFoundLogoStackView.isHidden = false
        }
    }
    
    private func setup() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        filteredChoosedByDatePickerDate(getSelectedWeekday())
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        collectionView.reloadData()
    }
    
    private func addNavButton() {
        let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        leftButton.tintColor = .ypBlack
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func getSelectedWeekday() -> Int {
        let selectedDate = datePicker.date
        return Calendar.current.component(.weekday, from: selectedDate)
    }
    
    @objc private func datePickerValueChanged(_ datePicker: UIDatePicker) {
        let selectedDate = datePicker.date
        setupCustomDatePickerView(with: selectedDate)
        filteredChoosedByDatePickerDate(getSelectedWeekday())
        dismiss(animated: false)
    }
    
    //MARK: - Filtered functions
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        let isSomeCompletedItem = completedTrackers.contains { completedItem in
            return isSameTrackerInTrackerCompleted(completedItem, id: id)
        }
        return isSomeCompletedItem
    }
    
    private func isSameTrackerInTrackerCompleted(_ completedItem: TrackerRecord, id: UUID) -> Bool {
        return completedItem.idExecutedTracker == id && Calendar.current.isDate(completedItem.dateExecuted, inSameDayAs: datePicker.date)
    }
    
    private func filteredChoosedByDatePickerDate(_ selectedWeekday: Int) {
        displayedTrackers = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                guard let timesheet = tracker.timesheet else {return false}
                let isDisplayed = timesheet.contains { selectedDayNumber in
                    selectedDayNumber == selectedWeekday
                }
                let idCopletedNonRegular: Bool = timesheet.isEmpty
                return isDisplayed || idCopletedNonRegular
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(name: category.name, trackers: trackers)
        }
        if displayedTrackers.isEmpty {
            showNotCreatedStub()
        } else {
            notCreatedLogoStackView.isHidden = true
        }
        collectionView.reloadData()
    }
    
    private func filteredByText(_ filteredText: String?) {
        guard let filteredText = filteredText?.lowercased() else {return}
        displayedTrackers = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let isFilteredText = filteredText.isEmpty || tracker.name.lowercased().contains(filteredText)
                guard let timesheet = tracker.timesheet else {return false}
                let selectedWeekday = self.getSelectedWeekday()
                let isDisplayedByDay: Bool = timesheet.isEmpty || timesheet.contains { selectedDayNumber in
                    selectedDayNumber == selectedWeekday
                }
                return isFilteredText && isDisplayedByDay
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(name: category.name, trackers: trackers)
        }
        if (displayedTrackers.isEmpty && !filteredText.isEmpty){
            showNotFoundStub()
            notCreatedLogoStackView.isHidden = true
        } else {
            notFoundLogoStackView.isHidden = true
        }
    }
    
    @objc private func addButtonTapped() {
        let eventTypeViewController = EventTypeViewController()
        eventTypeViewController.delegate = self
        let addButtonTappedTitle = NSLocalizedString("addButtonTappedTitle.title", comment: "")
        eventTypeViewController.title = addButtonTappedTitle
        let navigationController = UINavigationController(rootViewController: eventTypeViewController)
        present(navigationController, animated: true)
    }
    
    //MARK: - setup Stub image
    private func addNotCreatedLogo() {
        view.addSubview(notCreatedLogoStackView)
        setupErrorLogoLayout()
    }
    
    private func addNotFoundLogo() {
        view.addSubview(notFoundLogoStackView)
        setupNotFoundLogoLayout()
    }
    
    private func setupErrorLogoLayout() {
        NSLayoutConstraint.activate([
            notCreatedLogoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notCreatedLogoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        )
    }
    
    private func setupNotFoundLogoLayout() {
        NSLayoutConstraint.activate([
            notFoundLogoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notFoundLogoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        )
    }
    
    //MARK: - future date error alert
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - custom format datePicker label like Figma design
    private func setupCustomDatePickerView(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        currentDate = dateFormatter.string(from: date)
        
        if let dateLabel = datePicker.viewWithTag(100) as? UILabel {
            dateLabel.text = currentDate
        } else {
            datePicker.addCustomLabel(text: currentDate, width: 80, height: 44)
        }
        
        if let dateLabel = findAndModifyDatePickerLabel(in: datePicker.subviews) {
            dateLabel.isHidden = true
            dateLabel.font = .ypRegular17
        }
    }
    
    private func findAndModifyDatePickerLabel(in views: [UIView]) -> UILabel? {
        for view in views {
            if view is UILabel {
                let dateLabel = view as! UILabel
                return dateLabel
                break
            } else if let foundLabel = findAndModifyDatePickerLabel(in: view.subviews) {
                return foundLabel
            }
        }
        return nil
    }

    // MARK: - Alert Controller
    private func showDeleteAlert(with trackerItem: TrackerModel) {
        let alertController = UIAlertController(
            title: NSLocalizedString("alertController.title", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(
            title: NSLocalizedString("deleteButton.title", comment: ""),
            style: .destructive
        ) { [weak self] _ in
            guard let self else { return }
            self.deleteTracker(trackerId: trackerItem.idTracker)
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("cancelButton.title", comment: ""), style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: - UISearchResultsUpdating
extension TrackersViewController: UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        collectionView.reloadData()
    }
}

//MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate  {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filteredChoosedByDatePickerDate(getSelectedWeekday())
        notFoundLogoStackView.isHidden = true
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredByText(searchText)
        if searchText.isEmpty {
            filteredChoosedByDatePickerDate(getSelectedWeekday())
            collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return displayedTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return displayedTrackers[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.trackerCellIdentifier, for: indexPath) as? TrackerCollectionViewCell else {return UICollectionViewCell()}
        let trackerItem = displayedTrackers[indexPath.section].trackers[indexPath.row]
        let completedDays = completedTrackers.filter { $0.idExecutedTracker == trackerItem.idTracker }.count
        isCompleted = isTrackerCompletedToday(id: trackerItem.idTracker)
        cell.configurationCell(trackerItem, completedDays: completedDays, indexPath: indexPath, isTrackerCompleted: isCompleted, isPinned: trackerItem.isPinned)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header\(indexPath.section)"
            collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: id)
        default:
            id = ""
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackerHeaderView
            view.titleLabel.text = displayedTrackers[indexPath.section].name
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout & UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - params.paddingWidth) / CGFloat(params.cellCount)
        let heightCell = cellWidth * 148 / 167
        return CGSize(width: cellWidth, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: params.lineSpacingForHeaderAndCard,
                     left: params.leftInset,
                     bottom: params.lineSpacingForSectionAt,
                     right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return params.lineSpacingForSectionAt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    // MARK: Context menu configuration
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        let targetedPreview = configurationHighlightTargetedPreview(indexPath: indexPath)
        return targetedPreview
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfiguration configuration: UIContextMenuConfiguration,
                        dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        let targetedPreview = configurationHighlightTargetedPreview(indexPath: indexPath)
        return targetedPreview
    }
    
    private func configurationHighlightTargetedPreview(indexPath: IndexPath) -> UITargetedPreview {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell
        else { return UITargetedPreview(view: UIView(), parameters: UIPreviewParameters())}
        let view = cell.trackerBackgroundView
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        return UITargetedPreview(view: view,
                                 parameters: parameters)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else { return nil }
        let indexPath = indexPaths[0]

        let trackerItem = self.displayedTrackers[indexPath.section].trackers[indexPath.row]
        let pinActionTitle = NSLocalizedString("pinAction.title", comment: "")
        let unPinActionTitle = NSLocalizedString("unPinAction.title", comment: "")
        let editAction = NSLocalizedString("editAction.title", comment: "")
        let deleteAction = NSLocalizedString("deleteAction.title", comment: "")
       
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: trackerItem.isPinned ? unPinActionTitle : pinActionTitle) { [weak self] _ in
                    guard let self = self else { return }
                    self.configurationPinTracker(with: trackerItem)
                },
                UIAction(title: editAction) { [weak self] _ in
                    guard let self else { return }
                    let timeSheetViewController = TimeSheetViewController()
                    self.delegate = timeSheetViewController
                    self.editTracker(indexPath: indexPath)
                },
                UIAction(title: deleteAction, image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .destructive) {[weak self] _ in
                    guard let self else { return }
                    self.showDeleteAlert(with: trackerItem)
                }
            ])
        })
    }
    
    //MARK: -  context menu functions
     
     private func editTracker(indexPath: IndexPath) {
         let tracker = displayedTrackers[indexPath.section].trackers[indexPath.row]
         let category = categories[indexPath.section].name

         var completedDay = completedTrackers.filter { $0.idExecutedTracker == tracker.idTracker }.count
         let viewModel = NewTrackerVCViewModel()
         let editHabitViewController = NewTrackerViewController(viewModel: viewModel)
         editHabitViewController.delegate = self
         viewModel.typeEvent = .existingTtype
         
         viewModel.idTracker.value = tracker.idTracker
         viewModel.name.value = tracker.name
         viewModel.isPinned.value = tracker.isPinned
         viewModel.selectedCategory.value?.selectedCategory = category

         if let timesheet = tracker.timesheet,
                let timeSheetString = delegate?.getTimeSheetString(timeSheet: timesheet) {
             viewModel.addTimeSheet(timeSheetString, timesheet)
         }
         viewModel.selectedEmoji.value?.selectedEmoji = tracker.emoji
         viewModel.selectedColor.value?.selectedColors = tracker.color

         viewModel.daysCount.value = completedDay

         guard let typeEvent = viewModel.typeEvent?.localizedString() else {return}
         
         viewRouter?.switchToViewController(to: editHabitViewController, title: typeEvent)
     }
    
    private func configurationPinTracker(with tracker: TrackerModel) {
        let trackerID = tracker.idTracker
        do {
            try trackerStore.setTrackerPinState(with: trackerID)
            updateCategories()

        } catch {
            assertionFailure("Enabled to set pinned state \(CoreDataErrors.validationError(error))")
        }
    }
    
    private func updateCategories() {
        categories = []
        var pinnedTrackers: [TrackerModel] = []
        let categoryCoreData = trackerCategoryStore.getTrackersCategory()

        categoryCoreData.forEach { item in
            let trackerCoreData = item.trackers
            let pinTrackers = trackerCoreData.filter {$0.isPinned}
            pinnedTrackers.append(contentsOf: pinTrackers)
            
            let noPintrackers = trackerCoreData.filter {!$0.isPinned}
            if noPintrackers.count > 0 {
                categories.append(TrackerCategory(name: item.name, trackers: noPintrackers))
            }
        }
        if pinnedTrackers.count > 0 {
        let title = NSLocalizedString("pinCategory.title", comment: "")
            categories.insert(TrackerCategory(name: title, trackers: pinnedTrackers), at: 0)
        }
        filteredChoosedByDatePickerDate(getSelectedWeekday())
    }
}

//MARK: - TrackerCollectionViewCellDelegate
extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func markCompletedTracker(id: UUID, indexPath: IndexPath, isCompleted: Bool) {
        if datePicker.date > Date() {
            self.showAlert("Нельзя отмечать трекеры для будущих дат")
        } else if isCompleted {
            completedTrackers
                .filter { trackerRecord in
                    isSameTrackerInTrackerCompleted(trackerRecord, id: id)
                }.forEach { trackerRecord in
                    do {
                        try trackerRecordStore.deleteTrackerRecord(trackerRecord: trackerRecord)
                    } catch {
                        assertionFailure("Enabled to delete \(CoreDataErrors.deleteError(error))")
                    }
                }
            completedTrackers.removeAll { trackerRecord in
                isSameTrackerInTrackerCompleted(trackerRecord, id: id)
            }
        } else {
            let trackerRecord = TrackerRecord(idExecutedTracker: id, dateExecuted: datePicker.date)
            completedTrackers.append(trackerRecord)
            do {
                try trackerRecordStore.createTrackerRecordCoreData(from: trackerRecord)
            } catch {
                self.showAlert("Извините, ошибка работы с трекером \(String(describing: CoreDataErrors.validationError))")
            }
            filteredChoosedByDatePickerDate(getSelectedWeekday())
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - TrackerViewControllerDelegate
extension TrackersViewController: TrackersViewControllerDelegate {
    func getNewTracker(_ newTracker: TrackerModel?, categoryName: String?) {
        guard let newTracker = newTracker, let categoryName = categoryName else { return }
        do {
            try trackerCategoryStore.createNewTrackerRecord(newTracker: newTracker, for: categoryName)
        } catch {
            self.showAlert("Извините, ошибка создания трекера \(String(describing: CoreDataErrors.creatError))")
        }
        updateCategories()
    }
    
    func deleteTracker(trackerId: UUID) {
        trackerStore.deleteTracker(trackerId: trackerId)
         updateCategories()
     }

}


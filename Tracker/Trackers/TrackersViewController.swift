//
//  TrackersViewControllers.swift
//  Tracker
//
//  Created by Admin on 09.01.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var displayedTrackers: [TrackerCategory] = []
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()

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
        label.text = "Что будем отслеживать?"
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
        label.text = "Ничего не найдено"
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
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private var searchController: UISearchController?
    private var currentDate: String = ""
    private var isCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Mock data
        let trackerHabits1 = TrackerModel(idTracker: UUID(), name: "Поливать растения(привычка)", color: .colorSelection16, emoji: "😻", timesheet: [1, 2, 3, 4, 5, 6])
        let trackerNreg1 = TrackerModel(idTracker: UUID(), name: "Кошка заслонила камеру на созвоне(привычка)", color: .colorSelection18, emoji: "🥦", timesheet: [1, 3, 4, 5, 6])
        let trackerNreg2 = TrackerModel(idTracker: UUID(), name: " Прислали открытку в вотсапе(привычка)", color: .colorSelection18, emoji: "🎸", timesheet: [1, 3])
        let trackerNreg3 = TrackerModel(idTracker: UUID(), name: " Изучить IOS(нерегул)", color: .colorSelection14, emoji: "🎸", timesheet: [])
        
        let caregory1 = TrackerCategory(name: "Домашний уют", trackers: [trackerHabits1])
        let caregory2 = TrackerCategory(name: "Радостные мелочи", trackers: [trackerNreg1, trackerNreg2])
        let caregory3 = TrackerCategory(name: "Учеба", trackers: [trackerNreg3])
//        categories.append(caregory1)
//        categories.append(caregory2)
//        categories.append(caregory3)
        //MARK: - end Mock data
        
//        categories = trackerCategoryStore.getTrackersCategory()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.backgroundColor = .ypWhite
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        setupCustomDatePickerView(with: Date())
        addNavButton()
        setup()
        setupSearchController()
        showNotCreatedStub()
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
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
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
        eventTypeViewController.title = "Создание трекера"
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
            datePicker.addCustomLabel(text: currentDate, width: 100, height: 44)
        }
        
        if let dateLabel = findAndModifyDatePickerLabel(in: datePicker.subviews) {
            dateLabel.isHidden = true
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
        cell.configurationCell(trackerItem, completedDays: completedDays, indexPath: indexPath, isTrackerCompleted: isCompleted)
        
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
}

//MARK: - TrackerCollectionViewCellDelegate
extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func markCompletedTracker(id: UUID, indexPath: IndexPath, isCompleted: Bool) {
        
        if datePicker.date > Date() {
            self.showAlert("Нельзя отмечать трекеры для будущих дат")
        } else if isCompleted {
            completedTrackers.removeAll { trackerRecord in
                isSameTrackerInTrackerCompleted(trackerRecord, id: id)
                
            }
        } else {
            let trackerRecord = TrackerRecord(idExecutedTracker: id, dateExecuted: datePicker.date)
            do {
               try trackerRecordStore.createTrackerRecordCoreData(from: trackerRecord)
            } catch {
                assertionFailure("Failed to validate \(String(describing: CoreDataErrors.validationError))", file: #file, line: #line)
                self.showAlert("Извините, ошибка работы с трекером")
            }
            completedTrackers.append(trackerRecord)
            filteredChoosedByDatePickerDate(getSelectedWeekday())
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - TrackerViewControllerDelegate
extension TrackersViewController: TrackersViewControllerDelegate {
    func getNewTracker(_ newTracker: TrackerModel?, categoryName: String?) {
        guard let newTracker = newTracker, let categoryName = categoryName else { return }
//        let newCategory = TrackerCategory(name: categoryName, trackers: [newTracker])
//        categories.append(newCategory)
        do {
           try trackerCategoryStore.createNewTrackerRecord(newTracker: newTracker, for: categoryName)
         
        } catch {
            self.showAlert("Извините, ошибка создания трекера")
            assertionFailure("Failed to create \(String(describing: CoreDataErrors.creatError))", file: #file, line: #line)

        }
            categories = trackerCategoryStore.getTrackersCategory()
        print("try trackerCategoryStore.createNewTrackerRecord(newTracker: newTracker, for: categoryName)", categories)
        filteredChoosedByDatePickerDate(getSelectedWeekday())
    }
}
//MARK: - TBD
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//
//    }
//MARK: - iOS 16+
//if #available(iOS 16.0, *){
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
//
//    }
//
//} else {
// MARK: - iOS <16
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//
//    }



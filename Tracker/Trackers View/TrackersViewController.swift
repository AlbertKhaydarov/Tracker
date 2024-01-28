//
//  TrackersViewControllers.swift
//  Tracker
//
//  Created by Admin on 09.01.2024.
//

import UIKit

class TrackersViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    private var displayedTrackers: [TrackerCategory] = []
    
  
    //MARK: - add Stub Scene Logo
    lazy var errorTrackersLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "errorTrackersLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var errorTrackersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .ypMedium12
        return label
    }()
    
    lazy var errorLogoStackView: UIStackView = {
        let vStackView = UIStackView(arrangedSubviews: [errorTrackersLogo, errorTrackersLabel])
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
//        collection.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    let dateFormatter = DateFormatter()
    
    private var searchController: UISearchController?

    private var currentDate = Date()
    
    var isCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //MARK: - Mock data
        let trackerHabits1 = TrackerModel(id: UUID(), name: "Поливать растения", color: .colorSelection16, emoji: "😻", timesheet: [1, 2, 3, 4, 5, 6])
        let trackerNreg1 = TrackerModel(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: .colorSelection18, emoji: "🥦", timesheet: [1, 3, 4, 5, 6])
        let trackerNreg2 = TrackerModel(id: UUID(), name: " Прислали открытку в вотсапе", color: .colorSelection18, emoji: "🎸", timesheet: [1, 3])
        let trackerNreg3 = TrackerModel(id: UUID(), name: " Изучить IOS", color: .colorSelection14, emoji: "🎸", timesheet: [2, 3, 6])
        
        let caregory1 = TrackerCategory(name: "Домашний уют", trackers: [trackerHabits1])
        let caregory2 = TrackerCategory(name: "Радостные мелочи", trackers: [trackerNreg1, trackerNreg2])
        let caregory3 = TrackerCategory(name: "Учеба", trackers: [trackerNreg3])
        categories.append(caregory1)
        categories.append(caregory2)
        categories.append(caregory3)
        //MARK: - end Mock data
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.backgroundColor = .ypWhite
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        datePicker.setDate(currentDate, animated: false)
        dateFormatter.dateFormat = "dd.MM.yy"

        addNavButton()
        setup()
        setupSearchController()
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
    
    private func showErrorStub() {
        if displayedTrackers.isEmpty {
            addErrorLogo()
        }
    }
    
    private func setup() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        filteredChoosedByDatePickerDate(getSelectedWeekday())
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 120)
        ])
       
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
    
    @objc func datePickerValueChanged() {
        filteredChoosedByDatePickerDate(getSelectedWeekday())
        dismiss(animated: true)
    }
    
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
                guard let timesheet = tracker.timesheet, !timesheet.isEmpty else {return false}
                let isDisplayed = timesheet.contains { selectedDayNumber in
                    selectedDayNumber == selectedWeekday
                }
                return isDisplayed
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(name: category.name, trackers: trackers)
        }
        if displayedTrackers.isEmpty {
            showErrorStub()
            errorLogoStackView.isHidden = false
        } else {
            errorLogoStackView.isHidden = true
        }
        collectionView.reloadData()
    }
    
    private func filteredByText(_ filteredText: String?) {
        guard let filteredText = filteredText?.lowercased() else {return}
       
        displayedTrackers = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let isFilteredText = filteredText.isEmpty ||  tracker.name.lowercased().contains(filteredText)
                return isFilteredText
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(name: category.name, trackers: trackers)
        }
    }

    @objc func addButtonTapped() {
      let eventTypeViewController = EventTypeViewController()
        eventTypeViewController.title = "Создание трекера"
        let navigationController = UINavigationController(rootViewController: eventTypeViewController)
        present(navigationController, animated: true)
    }

    func addErrorLogo() {
            view.addSubview(errorLogoStackView)
            setupErrorLogoLayout()
    }
    
    func setupErrorLogoLayout() {
        NSLayoutConstraint.activate([
            errorLogoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLogoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        )
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension TrackersViewController: UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        collectionView.reloadData()
      }
}

extension TrackersViewController: UISearchBarDelegate  {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filteredChoosedByDatePickerDate(getSelectedWeekday())
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
        let completedDays = completedTrackers.filter { $0.idExecutedTracker == trackerItem.id }.count
        isCompleted = isTrackerCompletedToday(id: trackerItem.id)
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

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func markCompletedTracker(id: UUID, indexPath: IndexPath, isCompleted: Bool) {

        if datePicker.date > Date() {
            self.showAlert("Нельзя отмечать трекеры для будущих дат")
        } else if isCompleted {
            completedTrackers.removeAll { trackerRecord in
                isSameTrackerInTrackerCompleted(trackerRecord, id: id)

            }
        } else {
            print("2")
            let trackerRecord = TrackerRecord(idExecutedTracker: id, dateExecuted: datePicker.date)
            completedTrackers.append(trackerRecord)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
    //MARK: - TBD
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //            let cell = collectionView.cellForItem(at: indexPath) as? LetterCollectionViewCell
    //            cell?.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    //        }
    //
    //    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath) as? LetterCollectionViewCell
    //        cell?.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    //    }
    //// MARK: - iOS 16+
    //if #available(iOS 16.0, *){
    //    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
    //        guard indexPaths.count > 0 else {
    //                   return nil
    //               }
    //        let indexPath = indexPaths[0]
    //
    //               return UIContextMenuConfiguration(actionProvider: { actions in    // 4
    //                   return UIMenu(children: [                                     // 5
    //                       UIAction(title: "Bold") { [weak self] _ in                // 6
    //                           self?.makeBold(indexPath: indexPath)
    //                       },
    //                       UIAction(title: "Italic") { [weak self] _ in              // 7
    //                           self?.makeItalic(indexPath: indexPath)
    //                       },
    //                   ])
    //               })
    //    }
    //
    //    private func makeBold(indexPath: IndexPath) {
    //            let cell = collectionView.cellForItem(at: indexPath) as? LetterCollectionViewCell
    //            cell?.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    //        }
    //
    //    private func makeItalic(indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath) as? LetterCollectionViewCell
    //        cell?.titleLabel.font = UIFont.italicSystemFont(ofSize: 17)
    //    }
//} else {
    // MARK: - iOS <16
    //    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    //        return nil
    //    }
//}
//}


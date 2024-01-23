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
    
    private var datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    private var currentDate: Date {
        return datePicker.date
    }
    private lazy var weekday = {
        self.datePicker.calendar.component(.weekday, from: self.currentDate)
    }
    
    var isCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Mock data
        
        
        let trackerHabits1 = TrackerModel(id: UUID(), name: "Поливать растения", color: .colorSelection16, emoji: "😻", timesheet: [1, 2, 3])
        let trackerNreg1 = TrackerModel(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: .colorSelection18, emoji: "🥦", timesheet: [1, 3])
        let trackerNreg2 = TrackerModel(id: UUID(), name: " Прислали открытку в вотсапе", color: .colorSelection18, emoji: "🎸", timesheet: [1, 3])
        let trackerNreg3 = TrackerModel(id: UUID(), name: " Изучить IOS", color: .colorSelection14, emoji: "🎸", timesheet: [2, 3])
        
        let caregory1 = TrackerCategory(name: "Домашний уют", trackers: [trackerHabits1])
        let caregory2 = TrackerCategory(name: "Радостные мелочи", trackers: [trackerNreg1, trackerNreg2])
        let caregory3 = TrackerCategory(name: "Учеба", trackers: [trackerNreg3])
        categories.append(caregory1)
        categories.append(caregory2)
        categories.append(caregory3)
        
//        let dateString1 = "2024-01-09T13:09:43Z"
//        let dateString2 = "2024-01-08T13:09:43Z"
//        let trackRec1 = TrackerRecord(idExecutedTracker: trackerHabits1.id, dateExecuted: dateString1.dateTimeDateFromString ?? Date())
//        let trackRec2 = TrackerRecord(idExecutedTracker: trackerHabits1.id, dateExecuted: dateString2.dateTimeDateFromString ?? Date())
//        let trackRec3 = TrackerRecord(idExecutedTracker: trackerNreg1.id, dateExecuted: dateString1.dateTimeDateFromString ?? Date())
//        let trackRec4 = TrackerRecord(idExecutedTracker: trackerNreg2.id, dateExecuted: dateString1.dateTimeDateFromString ?? Date())
//        completedTrackers.append(trackRec1)
//        completedTrackers.append(trackRec2)
//        completedTrackers.append(trackRec3)
//        completedTrackers.append(trackRec4)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.backgroundColor = .ypWhite
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        datePicker.setDate(currentDate, animated: false)
        dateFormatter.dateFormat = "dd.MM.yy"
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        addNavButton()
        
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        //        searchController.searchResultsUpdater = self

        setup()
    }
    
    private func showErrorStub() {
        if displayedTrackers.isEmpty {
            addErrorLogo()
        }
    }
    
    private func setup() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let selectedWeekday = Calendar.current.component(.weekday, from: currentDate)
        filteredChoosedByDatePickerDate(selectedWeekday)
        
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
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let selectedWeekday = Calendar.current.component(.weekday, from: selectedDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        
//        print("Выбранная дата: \(formattedDate)")
        filteredChoosedByDatePickerDate(selectedWeekday)
      
    }
    private func isSameTrackerRecord(_ record: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(record.dateExecuted, inSameDayAs: datePicker.date)
        return record.idExecutedTracker == id && isSameDay
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord, id: id)
        }
    }
    
//    func isContaintsCompletedTrackerSameDate( in categories: [TrackerCategory], for id: UUID) -> Bool {
//        let iDs = categories.flatMap { $0.trackers.map { $0.id } }
//           let set = Set(iDs)
//
//        print(set)
//        return set.contains(id)
//
//    }
    
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
}

//extension TrackersViewController: UISearchResultsUpdating  {
//    func updateSearchResults(for searchController: UISearchController) {
//      }
//
//}

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
//       let isCompleted = isCompleted
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

 
        //        if datePicker.date > Date() {
        ////            self.showAlert("Нельзя отмечать трекеры для будущих дат")
        //        }
        let idSet = Set(completedTrackers.map{ $0.idExecutedTracker})
//        idSet.contains(id),
        print(isCompleted)
        if isCompleted {
            print("1")
//            let filteredTrackerRecord = completedTrackers.filter { trackerRecord in
//                isSameTrackerRecord(trackerRecord, id: id)
//            }
            
            completedTrackers.removeAll { trackerRecord in
                isSameTrackerRecord(trackerRecord, id: id)
            }
//            isCompleted = isTrackerCompletedToday(id: id)
        } else {
            print("2")
            let trackerRecord = TrackerRecord(idExecutedTracker: id, dateExecuted: datePicker.date)
            completedTrackers.append(trackerRecord)

//            isCompleted = isTrackerCompletedToday(id: id)
        }

        collectionView.reloadItems(at: [indexPath])
        //        (at: [indexPath])
    }
}
    //
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


//
//  TrackersViewControllers.swift
//  Tracker
//
//  Created by Admin on 09.01.2024.
//

import UIKit

class TrackersViewController: UIViewController {
// MARK: - заглушка, убрать
    var isTrackers: Bool = false

    private let emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
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

    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
  
    private var datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
       //MARK: - Mock data
        
        
        let trackerHabits1 = TrackerModel(id: UUID(), name: "Поливать растения", color: .colorSelection16, emoji: "😻", timesheet: [Timesheet(weekday: .monday), Timesheet(weekday: .tuesday)])
        let trackerNreg1 = TrackerModel(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: .colorSelection18, emoji: "🥦", timesheet: [])
        let trackerNreg2 = TrackerModel(id: UUID(), name: " Прислали открытку в вотсапе", color: .colorSelection18, emoji: "🎸", timesheet: [])
        
        let caregory1 = TrackerCategory(name: "Домашний уют", trackers: [trackerHabits1])
        let caregory2 = TrackerCategory(name: "Радостные мелочи", trackers: [trackerNreg1, trackerNreg2])
        categories.append(caregory1)
        categories.append(caregory2)

        let dateString1 = "2024-01-09T13:09:43Z"
        let dateString2 = "2024-01-08T13:09:43Z"
        let trackRec1 = TrackerRecord(idExecutedTracker: trackerHabits1.id, dateExecuted: dateString1.dateTimeDateFromString ?? Date())
        let trackRec2 = TrackerRecord(idExecutedTracker: trackerHabits1.id, dateExecuted: dateString2.dateTimeDateFromString ?? Date())
        let trackRec3 = TrackerRecord(idExecutedTracker: trackerNreg1.id, dateExecuted: dateString1.dateTimeDateFromString ?? Date())
        let trackRec4 = TrackerRecord(idExecutedTracker: trackerNreg2.id, dateExecuted: dateString1.dateTimeDateFromString ?? Date())
        completedTrackers.append(trackRec1)
        completedTrackers.append(trackRec2)
        completedTrackers.append(trackRec3)
        completedTrackers.append(trackRec4)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.backgroundColor = .ypWhite
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        let currentDate = Date()
        datePicker.setDate(currentDate, animated: false)
        dateFormatter.dateFormat = "dd.MM.yy"
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
   
        addNavButton()
        addErrorLogo (isTrackers: isTrackers)
        
        let searchController = UISearchController(searchResultsController: nil)
               navigationItem.hidesSearchBarWhenScrolling = false
               navigationItem.searchController = searchController
       //        searchController.searchResultsUpdater = self
        
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.trackerCellIdentifier)
        collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setup()
    }
   
    private func setup() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        if isTrackers == true {
            view.addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
              
            ])
        }
        
        NSLayoutConstraint.activate([
           
            datePicker.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func addNavButton() {
        let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        leftButton.tintColor = .ypBlack
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
 
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
      
        print("Выбранная дата: \(formattedDate)")
    }
    
    @objc func addButtonTapped() {
      let eventTypeViewController = EventTypeViewController()
        eventTypeViewController.title = "Создание трекера"
        let navigationController = UINavigationController(rootViewController: eventTypeViewController)
        present(navigationController, animated: true)
    }

    func addErrorLogo (isTrackers: Bool) {
        if !isTrackers {
            view.addSubview(errorLogoStackView)
            setupLayout()
        }
    }
    
    func setupLayout() {
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
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.trackerCellIdentifier, for: indexPath) as? TrackerCollectionViewCell else {return UICollectionViewCell()}
        let trackerItem = categories[indexPath.section].trackers[indexPath.row]
        cell.trackerLabel.text = trackerItem.name
        cell.emojiLabel.text = trackerItem.emoji
        cell.addQuantityButton.backgroundColor = trackerItem.color
        cell.trackerBackgroundView.backgroundColor = trackerItem.color
        
        //MARK: - сделать проверку на дату
        cell.addQuantityButtonSetImage(isTrackerCompleted: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackerHeaderView
        view.titleLabel.text = categories[indexPath.section].name
        
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout & UICollectionViewDelegate{
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
            let indexPath = IndexPath(row: 0, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
    
            return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                             height: UIView.layoutFittingExpandedSize.height),
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .fittingSizeLevel)
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let padding = CollectionViewPadding.interitemSpacingForSectionAt.rawValue + 16 + 16 /*+ CollectionViewPadding.interitemSpacingForSectionAt.rawValue*/
            let cellWidth = (collectionView.bounds.width - padding) / 2
            
            return CGSize(width: cellWidth, height: cellWidth * 148 / 167)
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return CollectionViewPadding.interitemSpacingForSectionAt.rawValue
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewPadding.lineSpacingForSectionAt.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: CollectionViewPadding.lineSpacingForHeaderAndCard.rawValue,
                     left: 16,
                     bottom: CollectionViewPadding.lineSpacingForSectionAt.rawValue,
                     right: 16)
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
}


//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Admin on 09.01.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private var completedTrackersCount: Int = 0
    private var bestPeriodCount: Int = 0
    private var idealDaysCount: Int = 0
    private var averageValueCount: Int = 0
    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "emptyStatistics.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubTextTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("stubTextTitleLabel.text", comment: "")
        label.textColor = .ypBlack
        label.font = .ypMedium12
        return label
    }()
    
    private lazy var completedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var countCompletedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .ypBold34
        return label
    }()
    
    private lazy var completedTrackerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("completedTrackerTitleLabel.title", comment: "")
        label.textAlignment = .left
        label.textColor = .ypBlack
        label.font = .ypMedium12
        return label
    }()
    
    private lazy var bestPeriodView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var bestPeriodLabel: UILabel = {
        let label = UILabel()
        label.font = .ypMedium12
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.text = NSLocalizedString("bestPeriodLabel.title", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bestPeriodCounter: UILabel = {
        let label = UILabel()
        label.font = .ypBold34
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var idealDaysView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var idealDaysLabel: UILabel = {
        let label = UILabel()
        label.font = .ypMedium12
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.text = NSLocalizedString("idealDaysLabel.title", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var idealDaysCounter: UILabel = {
        let label = UILabel()
        label.font = .ypBold34
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var averageValueView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setGradientBorder()
        return view
    }()
    
    private lazy var averageValueLabel: UILabel = {
        let label = UILabel()
        label.font = .ypMedium12
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.text = NSLocalizedString("averageValueLabel.title", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var averageValueCounter: UILabel = {
        let label = UILabel()
        label.font = .ypBold34
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.addArrangedSubview(bestPeriodView)
        stackView.addArrangedSubview(idealDaysView)
        stackView.addArrangedSubview(completedView)
        stackView.addArrangedSubview(averageValueView)
        stackView.spacing = 12
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        let titleLabel = NSLocalizedString("statistics.title", comment: "")
        title = titleLabel
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        setupViews()
        setupLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBestPeriod()
        getIdealDays()
        getStatistic()
        getAverageValue()
        showStubView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bestPeriodView.setGradientBorder()
        idealDaysView.setGradientBorder()
        completedView.setGradientBorder()
        averageValueView.setGradientBorder()
    }
    
    private func setupViews() {
        view.addSubview(stubImageView)
        view.addSubview(stubTextTitleLabel)
        view.addSubview(stackView)
        
        bestPeriodView.addSubview(bestPeriodCounter)
        bestPeriodView.addSubview(bestPeriodLabel)
        
        idealDaysView.addSubview(idealDaysCounter)
        idealDaysView.addSubview(idealDaysLabel)
        
        completedView.addSubview(countCompletedLabel)
        completedView.addSubview(completedTrackerTitleLabel)
        
        averageValueView.addSubview(averageValueCounter)
        averageValueView.addSubview(averageValueLabel)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 193),
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stubTextTitleLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubTextTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            
            bestPeriodView.heightAnchor.constraint(equalToConstant: 90),
            bestPeriodView.widthAnchor.constraint(equalToConstant: 343),
            bestPeriodView.topAnchor.constraint(equalTo: stackView.topAnchor),
            bestPeriodView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            bestPeriodView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            bestPeriodCounter.leadingAnchor.constraint(equalTo: bestPeriodView.leadingAnchor, constant: 12),
            bestPeriodCounter.topAnchor.constraint(equalTo: bestPeriodView.topAnchor, constant: 12),
            bestPeriodCounter.trailingAnchor.constraint(equalTo: bestPeriodView.trailingAnchor, constant: -12),
            
            bestPeriodLabel.leadingAnchor.constraint(equalTo: bestPeriodCounter.leadingAnchor),
            bestPeriodLabel.trailingAnchor.constraint(equalTo: bestPeriodCounter.trailingAnchor),
            bestPeriodLabel.bottomAnchor.constraint(equalTo: bestPeriodView.bottomAnchor, constant: -12),
            
            idealDaysView.heightAnchor.constraint(equalToConstant: 90),
            idealDaysView.widthAnchor.constraint(equalToConstant: 343),
            idealDaysView.topAnchor.constraint(equalTo: bestPeriodView.bottomAnchor, constant: 12),
            idealDaysView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            idealDaysView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            idealDaysCounter.topAnchor.constraint(equalTo: idealDaysView.topAnchor, constant: 12),
            idealDaysCounter.leadingAnchor.constraint(equalTo: idealDaysView.leadingAnchor, constant: 12),
            idealDaysCounter.trailingAnchor.constraint(equalTo: idealDaysView.trailingAnchor, constant: -12),
            
            idealDaysLabel.leadingAnchor.constraint(equalTo: idealDaysCounter.leadingAnchor),
            idealDaysLabel.trailingAnchor.constraint(equalTo: idealDaysCounter.trailingAnchor),
            idealDaysLabel.bottomAnchor.constraint(equalTo: idealDaysView.bottomAnchor, constant: -12),
            
            completedView.heightAnchor.constraint(equalToConstant: 90),
            completedView.widthAnchor.constraint(equalToConstant: 343),
            completedView.topAnchor.constraint(equalTo: idealDaysView.bottomAnchor, constant: 12),
            completedView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            completedView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            countCompletedLabel.leadingAnchor.constraint(equalTo: completedView.leadingAnchor, constant: 12),
            countCompletedLabel.topAnchor.constraint(equalTo: completedView.topAnchor, constant: 12),
            countCompletedLabel.trailingAnchor.constraint(equalTo: completedView.trailingAnchor, constant: -12),
            
            completedTrackerTitleLabel.leadingAnchor.constraint(equalTo: countCompletedLabel.leadingAnchor),
            completedTrackerTitleLabel.trailingAnchor.constraint(equalTo: countCompletedLabel.trailingAnchor),
            completedTrackerTitleLabel.bottomAnchor.constraint(equalTo: completedView.bottomAnchor, constant: -12),
            
            averageValueView.heightAnchor.constraint(equalToConstant: 90),
            averageValueView.widthAnchor.constraint(equalToConstant: 343),
            averageValueView.topAnchor.constraint(equalTo: completedView.bottomAnchor, constant: 12),
            averageValueView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            averageValueView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            averageValueCounter.leadingAnchor.constraint(equalTo: averageValueView.leadingAnchor, constant: 12),
            averageValueCounter.topAnchor.constraint(equalTo: averageValueView.topAnchor, constant: 12),
            averageValueCounter.trailingAnchor.constraint(equalTo: averageValueView.trailingAnchor, constant: -12),
            
            averageValueLabel.leadingAnchor.constraint(equalTo: averageValueCounter.leadingAnchor),
            averageValueLabel.trailingAnchor.constraint(equalTo: averageValueCounter.trailingAnchor),
            averageValueLabel.bottomAnchor.constraint(equalTo: averageValueView.bottomAnchor, constant: -12),
        ])
    }
    
    private func getStatistic() {
        self.completedTrackersCount = getCompletedTrackers()
        countCompletedLabel.text = "\(completedTrackersCount)"
    }
    
    private func getBestPeriod() {
        self.bestPeriodCount = getBestPeriodCount()
        bestPeriodCounter.text = "\(bestPeriodCount)"
    }
    
    private func getIdealDays() {
        self.idealDaysCount = getIdealdaysCount()
        idealDaysCounter.text = "\(idealDaysCount)"
    }
    
    private func getAverageValue() {
        self.averageValueCount = getAverageValueNumber()
        averageValueCounter.text = "\(averageValueCount)"
    }
    
    private func getCompletedTrackers() -> Int {
        var completedTrackers = 0
        do {
            completedTrackers = try trackerRecordStore.getCountCompletedTrackers()
        } catch {
            assertionFailure("Failed to get \(String(describing: CoreDataErrors.decodingError(error)))", file: #file, line: #line)
            return 0
        }
        return completedTrackers
    }
    
    private func getBestPeriodCount() -> Int {
        var trackerRecords: [TrackerRecord] = []
        do {
            trackerRecords = try trackerRecordStore.getTrackersRecords()
        } catch {
            assertionFailure("Failed to get \(String(describing: CoreDataErrors.decodingError(error)))", file: #file, line: #line)
            return 0
        }
        
        var bestPeriodCounter: [UUID: Int] = [:]
        
        for item in trackerRecords {
            if bestPeriodCounter.keys.contains(item.idExecutedTracker) {
                var count = bestPeriodCounter[item.idExecutedTracker]!
                count += 1
                
                bestPeriodCounter[item.idExecutedTracker] = count
            } else {
                
                bestPeriodCounter[item.idExecutedTracker] = 1
            }
        }
        return bestPeriodCounter.values.max() ?? 0
    }
    
    private func getAverageValueNumber() -> Int {
        var trackerRecords: [TrackerRecord]?
        do {
            trackerRecords = try trackerRecordStore.getTrackersRecords()
        } catch {
            assertionFailure("Failed to get \(String(describing: CoreDataErrors.decodingError(error)))", file: #file, line: #line)
            return 0
        }
        
        guard let trackerRecords = trackerRecords else {return 0}
        
        if !trackerRecords.isEmpty {
            let trackersDateGroupe = Dictionary(grouping: trackerRecords) { Calendar.current.startOfDay(for: $0.dateExecuted) }
            let averageCount = trackersDateGroupe.values.map { Double($0.count) }.reduce(0, +) / Double(trackersDateGroupe.count)
            return Int(averageCount)
        } else {
            return 0
        }
    }
    
    private func getIdealdaysCount() -> Int {
        var daysCount = 0
        
        let categories = trackerCategoryStore.getTrackersCategory()
        let trackerPlan: [TrackerModel] = categories.flatMap { $0.trackers }
        
        var trackerRecords: [TrackerRecord] = []
        do {
            trackerRecords = try trackerRecordStore.getTrackersRecords()
        } catch {
            assertionFailure("Failed to get \(String(describing: CoreDataErrors.decodingError(error)))", file: #file, line: #line)
            return 0
        }
        
        var completedDict: [Date: Set<UUID>] = [:]
        for record in trackerRecords {
            if completedDict[record.dateExecuted] == nil {
                completedDict[record.dateExecuted] = Set<UUID>()
            }
            completedDict[record.dateExecuted]?.insert(record.idExecutedTracker)
        }
        
        for date in completedDict.keys {
            let plannedTrackers = trackerPlan.filter { tracker in
                
                if tracker.timesheet?.count == 0 {
                    return true
                } else {
                    let timesheetContains = tracker.timesheet?.contains(Calendar.current.component(.weekday, from: date))
                    return timesheetContains ?? false
                }
            }
            print(plannedTrackers)
            let plannedTrackersIds = Set(plannedTrackers.map { $0.idTracker })
            let completedTrackersIds = completedDict[date]
            if plannedTrackersIds.count == completedTrackersIds?.count {
                daysCount += 1
            }
        }
        return daysCount
    }
    
    private func showStubView() {
        let isShow = (completedTrackersCount == 0 && bestPeriodCount == 0 && idealDaysCount == 0 && averageValueCount == 0 )
        stubImageView.isHidden = !isShow
        stubTextTitleLabel.isHidden = !isShow
        bestPeriodView.isHidden = isShow
        idealDaysView.isHidden = isShow
        completedView.isHidden = isShow
        averageValueView.isHidden = isShow
    }
}

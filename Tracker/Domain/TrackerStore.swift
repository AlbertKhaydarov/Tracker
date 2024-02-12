//
//  TrackerStore.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 08.02.2024.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    convenience override init() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Could not allow access to the application \(String(describing: CoreDataErrors.persistentStoreError))")
           }
           self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    private func getTrackersArray() throws -> [TrackerModel] {
        guard let object = self.fetchedResultsController.fetchedObjects else {
           throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
        }
        var trackers = [TrackerModel]()
            do {
                trackers = try object.map { try self.getTracker(from: $0)}
            } catch {
                throw CoreDataErrors.decodingError(error)
            }
        return trackers
    }
    
    func getTracker(from trackerCoreData: TrackerCoreData) throws -> TrackerModel {
        guard let idTracker = trackerCoreData.idTracker,
              let name = trackerCoreData.name,
              let color = trackerCoreData.color,
              let emoji = trackerCoreData.emoji,
              let timesheet = trackerCoreData.timesheet
        else {
            throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
        }
        if let transformedTimesheet = TimeSheetDaysValueTransformer().transformedValue(timesheet) as? [Int] {
            return TrackerModel(idTracker: idTracker,
                                name: name,
                                color: uiColorMarshalling.color(from: color),
                                emoji: emoji,
                                timesheet: transformedTimesheet)
        } else {
            throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
        }
    }
    
    func createTrackerCoreData(_ tracker: TrackerModel) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.idTracker = tracker.idTracker
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        if let transformedTimesheet = TimeSheetDaysValueTransformer().transformedValue(tracker.timesheet) as? NSObject {
            trackerCoreData.timesheet = transformedTimesheet
        } else {
            throw CoreDataErrors.creatError(NSError(domain: "CoreData", code: 0, userInfo: nil))
        }
        return trackerCoreData
    }
}

//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 08.02.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.dateExecuted, ascending: true)
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
    
    func getTrackersRecords() throws -> [TrackerRecord] {
        guard let object = self.fetchedResultsController.fetchedObjects else {
            throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
        }
        var records: [TrackerRecord] = []
        do {
            records = try object.map { try self.getRecord(from: $0)}
        } catch {
            throw CoreDataErrors.decodingError(error)
        }
        return records
    }
    
    private func getRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let idExecuted = trackerRecordCoreData.idExecutedTracker,
              let dateExecuted = trackerRecordCoreData.dateExecuted
        else {
            throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
        }
            return TrackerRecord(idExecutedTracker: idExecuted,
                                 dateExecuted: dateExecuted)
    }
    
    func createTrackerRecordCoreData(from trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.idExecutedTracker = trackerRecord.idExecutedTracker
        trackerRecordCoreData.dateExecuted = trackerRecord.dateExecuted
       
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            try appDelegate.saveContext()
        }
    }
    
}

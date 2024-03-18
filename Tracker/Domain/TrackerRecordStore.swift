//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 08.02.2024.
//

import CoreData
import UIKit

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
    
    func createTrackerRecordCoreData(from trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.idExecutedTracker = trackerRecord.idExecutedTracker
        trackerRecordCoreData.dateExecuted = trackerRecord.dateExecuted
        do {
            try context.save()
        } catch {
            print("Failed to save: \(CoreDataErrors.saveError(error)), \(error.localizedDescription)")
        }
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        let datePredicate = NSPredicate(format: "dateExecuted == %@", trackerRecord.dateExecuted as NSDate)
        let idPredicate = NSPredicate(format: "idExecutedTracker == %@", trackerRecord.idExecutedTracker as CVarArg )
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, idPredicate])
        request.predicate = compoundPredicate
        
        guard let trackerRecords = try? context.fetch(request) else {
            assertionFailure("Enabled to fetch(request) \(CoreDataErrors.fetchError(NSError(domain: "CoreData", code: 0, userInfo: nil)))")
            return
        }
        
        if let trackerRecordCoreData = trackerRecords.first {
            context.delete(trackerRecordCoreData)
            do {
                try context.save()
            } catch {
                print("Failed to save: \(CoreDataErrors.saveError(error)), \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTrackerRecord(withID trackerID: UUID) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: " %K == %@", #keyPath(TrackerRecordCoreData.idExecutedTracker),trackerID as CVarArg)
        do {
            let trackerRecordsCoreData = try context.fetch(request)
            
            for record in trackerRecordsCoreData {
                context.delete(record)
            }
            try context.save()
        } catch {
            print("Failed to save: \(CoreDataErrors.saveError(error)), \(error.localizedDescription)")
        }
    }
    
    func getCountCompletedTrackers() throws -> Int {
        let request = TrackerRecordCoreData.fetchRequest()
        let trackerRecordsCoreData = try context.fetch(request)
        var trackerRecords: [TrackerRecord] = []
        do {
            trackerRecords = try trackerRecordsCoreData.map { item in
                guard let iDtracker = item.idExecutedTracker,
                      let dateTracker = item.dateExecuted
                else {
                    throw CoreDataErrors.fetchError(NSError(domain: "CoreData", code: 0, userInfo: nil))
                    
                }
                return TrackerRecord(idExecutedTracker: iDtracker, dateExecuted: dateTracker)
            }
        } catch {
            print("Failed to save: \(CoreDataErrors.fetchError(error)), \(error.localizedDescription)")
        }
        return trackerRecords.count
    }
    
    func getTrackersRecords() throws -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        let trackerRecordsCoreData = try context.fetch(request)
        var trackerRecords: [TrackerRecord] = []
        do {
            trackerRecords = try trackerRecordsCoreData.map { item in
                guard let iDtracker = item.idExecutedTracker,
                      let dateTracker = item.dateExecuted
                else {
                    throw CoreDataErrors.fetchError(NSError(domain: "CoreData", code: 0, userInfo: nil))
                    
                }
                return TrackerRecord(idExecutedTracker: iDtracker, dateExecuted: dateTracker)
            }
        } catch {
            print("Failed to save: \(CoreDataErrors.fetchError(error)), \(error.localizedDescription)")
        }
        return trackerRecords
    }
}

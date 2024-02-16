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
        //TODO: - удалить после отладки
//                        deleteAllData()
    }
    
    //TODO: - удалить после отладки
    private func deleteAllData() {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Could not allow access to the application \(String(describing: CoreDataErrors.persistentStoreError))")
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerRecordCoreData")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(batchDeleteRequest)
        } catch {
            print("Failed to delete all data: \(error)")
        }
    }
    
    func getTrackersRecords() throws -> [TrackerRecord] {
        guard let object = self.fetchedResultsController.fetchedObjects else {
            throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
        }
        var records: [TrackerRecord] = []
        records = object.compactMap({ item in
            do {
                let record = try self.getRecord(from: item)
                
                return record
                
            } catch {
                assertionFailure("Failed to create \(String(describing: CoreDataErrors.decodingError(error)))", file: #file, line: #line)
                return nil
            }
        })
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
}

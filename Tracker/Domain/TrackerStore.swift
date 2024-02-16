//
//  TrackerStore.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 08.02.2024.
//
import CoreData
import UIKit

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private let arrayMarshalling = ArrayMarshalling()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.resultType = .managedObjectResultType
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
    
    //TODO: - удалить после отладки
    func deleteAllData() {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Could not allow access to the application \(String(describing: CoreDataErrors.persistentStoreError))")
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCoreData")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(batchDeleteRequest)
        } catch {
            print("Failed to delete all data: \(error)")
        }
    }
    
    func getTracker(from trackerCoreData: TrackerCoreData) throws -> TrackerModel {
        guard
            let idTrackerCoreData = trackerCoreData.idTracker,
            let nameCoreData = trackerCoreData.name,
            let colorCoreData = trackerCoreData.color,
            let emojiCoreData = trackerCoreData.emoji
        else {
            throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
        }
        
        let timeSheetTransform = arrayMarshalling.reverseTransformedValue(trackerCoreData.timesheet as? Data)
        return TrackerModel(idTracker: idTrackerCoreData,
                            name: nameCoreData,
                            color: uiColorMarshalling.color(from: colorCoreData),
                            emoji: emojiCoreData,
                            timesheet: timeSheetTransform)
    }
    
    func createTrackerCoreData(_ tracker: TrackerModel) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.idTracker = tracker.idTracker
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        
        let transformedTimesheet = arrayMarshalling.transformedValue(tracker.timesheet!)
        trackerCoreData.timesheet = transformedTimesheet
        
        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save \(String(describing: CoreDataErrors.saveError(error)))", file: #file, line: #line)
        }
        return trackerCoreData
    }
}

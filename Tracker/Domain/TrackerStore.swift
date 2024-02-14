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
    private let arrayMarshalling = ArrayMarshalling()
    
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
//        deleteAllData()
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
//       print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    //MARK: - удалить после отладки
    func deleteAllData() {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Could not allow access to the application \(String(describing: CoreDataErrors.persistentStoreError))")
           }
       
//        let fetchRequest = TrackerCoreData.fetchRequest()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCoreData")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(batchDeleteRequest)
        } catch {
            print("Failed to delete all data: \(error)")
        }
    }


    func getTrackersArray() -> [TrackerModel] {
        guard let object = self.fetchedResultsController.fetchedObjects else {
            assertionFailure("Failed to create \(String(describing: CoreDataErrors.creatError))", file: #file, line: #line)
          return []
        }
        var trackers = [TrackerModel]()
//            do {
//                trackers = try object.map { try self.getTracker(from: $0)}
                trackers = object.compactMap({ item in
                    do {
                        let tracker = try self.getTracker(from: item)
                        return tracker
                    } catch {
                        assertionFailure("Failed to create \(String(describing: CoreDataErrors.decodingError(error)))", file: #file, line: #line)
                        return nil
                    }
                })
        return trackers
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
//        let timeSheetTransform = TimeSheetDaysValueTransformer().reverseTransformedValue(trackerCoreData.timesheet) as? [Int]
        let timeSheetTransform = arrayMarshalling.reverseTransformedValue(trackerCoreData.timesheet as? Data)
        print(#function, timeSheetTransform)
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
       
      
//        let transformedTimesheet  = try NSKeyedArchiver.archivedData(withRootObject: tracker.timesheet, requiringSecureCoding: false) as! NSObject
//        if let transformedTimesheet = TimeSheetDaysValueTransformer().transformedValue(tracker.timesheet) as? NSData {
        
        let transformedTimesheet = arrayMarshalling.transformedValue(tracker.timesheet!)
        
        trackerCoreData.timesheet = transformedTimesheet
                print(#function, trackerCoreData.timesheet)
                do {
                           try context.save()
                       } catch {
                           throw CoreDataErrors.creatError(NSError(domain: "CoreData", code: 4, userInfo: nil))
                       }

//        } else {
//            throw CoreDataErrors.creatError(NSError(domain: "CoreData", code: 3, userInfo: nil))
//        }

        return trackerCoreData
    }
}

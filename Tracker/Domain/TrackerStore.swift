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
//        deleteAllData()
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
       print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

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
                    print("2",item.timesheet)
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
     
        guard let idTrackerCoreData = trackerCoreData.idTracker,
              let nameCoreData = trackerCoreData.name,
              let colorCoreData = trackerCoreData.color,
              let emojiCoreData = trackerCoreData.emoji,
              let timesheetCoreData = trackerCoreData.timesheet
        else {
            throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 1, userInfo: nil))
        }
        let timeSheet = TimeSheetDaysValueTransformer().reverseTransformedValue(trackerCoreData.timesheet) as? [Int]
      
//        if let timeSheet = TimeSheetDaysValueTransformer().reverseTransformedValue(trackerCoreData.timesheet) as? [Int] {
           
            return TrackerModel(idTracker: idTrackerCoreData,
                                name: nameCoreData,
                                color: uiColorMarshalling.color(from: colorCoreData),
                                emoji: emojiCoreData,
                                timesheet: timeSheet)
//        } else {
//            throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
//        }
        
    }
    
    func createTrackerCoreData(_ tracker: TrackerModel) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.idTracker = tracker.idTracker
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
 
        let transformedTimesheet = TimeSheetDaysValueTransformer().transformedValue(tracker.timesheet) as? NSObject  
            if let  transformedTimesheet = transformedTimesheet {
//         let transformedTimesheet = TimeSheetDaysValueTransformer().transformedValue(tracker.timesheet) as? NSObject
            trackerCoreData.timesheet = transformedTimesheet
   

           

            print("2",transformedTimesheet)
        } else {
            throw CoreDataErrors.creatError(NSError(domain: "CoreData", code: 3, userInfo: nil))
        }

        return trackerCoreData
    }
}

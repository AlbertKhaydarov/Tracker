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
                            timesheet: timeSheetTransform,
                            isPinned: trackerCoreData.isPinned)
    }
    
    func createTrackerCoreData(_ tracker: TrackerModel) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.idTracker = tracker.idTracker
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.isPinned = tracker.isPinned
        let transformedTimesheet = arrayMarshalling.transformedValue(tracker.timesheet!)
        trackerCoreData.timesheet = transformedTimesheet
        
        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save \(String(describing: CoreDataErrors.saveError(error)))", file: #file, line: #line)
        }
        return trackerCoreData
    }
    
    let titlePinCategory = NSLocalizedString("pinCategory.title", comment: "")
   
    func isTrackerPinned(with indexPath: IndexPath) -> Bool {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        return trackerCoreData.trackerCategory?.name == titlePinCategory ? true : false
    }
    
    func fetchTracker(with indexPath: IndexPath) throws -> TrackerModel? {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        var trackerModel: TrackerModel?
        do {
            trackerModel = try getTracker(from: trackerCoreData)
        } catch {
            assertionFailure("Failed to fetch \(String(describing: CoreDataErrors.fetchError(error)))", file: #file, line: #line)
        }
        return trackerModel
    }
    
    func setTrackerPinState(with iDTracker: UUID) throws {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.idTracker), iDTracker as CVarArg)
        var trackerCoreData: TrackerCoreData?
        do {
            trackerCoreData = try context.fetch(fetchRequest).first
        } catch {
            assertionFailure("Failed to save \(String(describing: CoreDataErrors.saveError(error)))", file: #file, line: #line)
        }
        
        trackerCoreData?.isPinned.toggle()
        try context.save()
    }
    
//    func deleteTracker(tracker: TrackerModel) {
//        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
//        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.idTracker), tracker.idTracker.uuidString)
//        guard let items = try? context.fetch(request) else {
//            assertionFailure("Failed to fetch \(String(describing: CoreDataErrors.fetchError))", file: #file, line: #line)
//            return
//        }
//        guard let deleteItem = items.first else {return}
//        context.delete(deleteItem)
//        do {
//            try context.save()
//        } catch {
//           assertionFailure("Failed to save \(String(describing: CoreDataErrors.saveError(error)))", file: #file, line: #line)
//        }
//    }
    
    func deleteTracker(trackerId: UUID) {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.idTracker), trackerId.uuidString)
        guard let items = try? context.fetch(request) else {
            assertionFailure("Failed to fetch \(String(describing: CoreDataErrors.fetchError))", file: #file, line: #line)
            return
        }
        guard let deleteItem = items.first else {return}
        context.delete(deleteItem)
        do {
            try context.save()
        } catch {
           assertionFailure("Failed to save \(String(describing: CoreDataErrors.saveError(error)))", file: #file, line: #line)
        }
    }
//    func numberOfSections() -> Int {
//        return fetchedResultsController.sections?.count ?? 0
//    }
//
//    func numberOfItemsInSection(_ section: Int) -> Int {
//        fetchedResultsController.sections?[section].numberOfObjects ?? 0
//    }
//    
//    func title(of section: Int) -> String? {
//        fetchedResultsController.sections?[section].name
//    }
}

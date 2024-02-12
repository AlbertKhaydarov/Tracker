//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 08.02.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackersCategoryStoreUpdate.Move>?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
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
    
    func getTrackersCategory() throws -> [TrackerCategory] {
        guard let object = self.fetchedResultsController.fetchedObjects else {
            throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
        }

        var categories: [TrackerCategory] = []
        do {
            categories = try object.map { item in
                guard let name = item.name,
                      let trackersCoreData = item.trackers
                else {
                    throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
                }
                
                let trackers = try trackersCoreData.map { trackerCoreData in
                    guard let trackerCoreData = trackerCoreData as? TrackerCoreData else {
                        throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
                    }

                    let tracker = try trackerStore.getTracker(from: trackerCoreData)
                    return tracker
                }
                let category = TrackerCategory(name: name,
                                               trackers: trackers)
                return category
//                TrackerCategory(name: name,
//                                       trackers: trackers)
            }
        } catch {
            throw CoreDataErrors.decodingError(error)
        }
        return categories
    }
    
    func createNewTrackerRecord(newTracker: TrackerModel, for category: String) throws {
        let trackerCoreData = try trackerStore.createTrackerCoreData(newTracker)
        
        if let category = try? fetchedCategory(name: category) {
            
          
            guard let trackers = category.trackers,
                  var newTrackers = trackers.allObjects as? [TrackerCoreData]
            else { return }
            print(newTrackers)
            newTrackers.append(trackerCoreData)
          
            category.trackers = NSSet(array: newTrackers)
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.name = category
            newCategory.trackers = NSSet(array: [trackerCoreData])
        }
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            try appDelegate.saveContext()
//        }

        do {
            try context.save()
        } catch {
            print("Unable to save category. Error: \(error), \(error.localizedDescription)")
        }
    }
    
    private func fetchedCategory(name: String) throws -> TrackerCategoryCoreData? {
        let request = fetchedResultsController.fetchRequest
//        request.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", name])
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name))
        do {
            let category = try context.fetch(request)
            return category.first
        } catch {
            throw CoreDataErrors.fetchError(error)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }
}

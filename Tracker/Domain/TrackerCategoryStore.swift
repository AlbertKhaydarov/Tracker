//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 08.02.2024.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackersCategoryStoreUpdate.Move>?
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)
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
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        //TODO: - удалить после отладки
        //        if let libraryPath = paths.first {
        //            print("Library path: \(libraryPath)")
        //        }
    }
    
    var categoryTypes: [TrackerCategoryCoreData] {
        return self.fetchedResultsController.fetchedObjects ?? []
    }
    
    func getTrackersCategory() -> [TrackerCategory] {
        guard let object = self.fetchedResultsController.fetchedObjects else {
            assertionFailure("Failed to create \(String(describing: CoreDataErrors.creatError))", file: #file, line: #line)
            return []
        }
        var categories: [TrackerCategory] = []
        do {
            categories =  try object.map { item in
                guard let name = item.name,
                      let trackersCoreData = item.trackers
                else {
                    throw CoreDataErrors.decodingError(NSError(domain: "CoreData", code: 0, userInfo: nil))
                }
                let trackers = trackersCoreData.compactMap { trackerCoreData in
                    if let trackerCoreData = trackerCoreData as? TrackerCoreData {
                        do {
                            return try trackerStore.getTracker(from: trackerCoreData)
                        } catch {
                            assertionFailure("Failed to create \(String(describing: CoreDataErrors.decodingError(error)))", file: #file, line: #line)
                        }
                    }
                    return nil
                }
                
                // MARK: - sort trackers (by name)
                let sortedTrackers = trackers.sorted { $0.name < $1.name }
                let category = TrackerCategory(name: name,
                                               trackers: sortedTrackers)
                return category
            }
        } catch {
            assertionFailure("Failed to create \(String(describing: CoreDataErrors.decodingError(error)))", file: #file, line: #line)
        }
        return categories
    }
    
    func addNewCategoryType(_ categoryType: TrackerCategory) throws {
        let categoryTypeCoreData = TrackerCategoryCoreData(context: context)
        categoryTypeCoreData.name = categoryType.name
        categoryTypeCoreData.trackers = []
        do {
            try context.save()
        } catch {
            print("Failed to save CoreData: \(error), \(error.localizedDescription)")
        }
    }
    
    func deleteCategory(at indexPath: IndexPath) throws {
        let categoryTypeCoreData = fetchedResultsController.object(at: indexPath)
        context.delete(categoryTypeCoreData)
        do {
            try context.save()
        } catch {
            print("Failed to save CoreData: \(error), \(error.localizedDescription)")
        }
    }
    
    func createNewTrackerRecord(newTracker: TrackerModel, for category: String) throws {
        let trackerCoreData = try trackerStore.createTrackerCoreData(newTracker)
        if let category = try fetchedCategory(name: category) {
            let newTrackers = category.mutableSetValue(forKey: "trackers")
            newTrackers.add(trackerCoreData)
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.name = category
            newCategory.addToTrackers(trackerCoreData)
        }
        do {
            try context.save()
        } catch {
            print("Failed to save CoreData: \(error), \(error.localizedDescription)")
        }
    }
    
    private func fetchedCategory(name: String) throws -> TrackerCategoryCoreData? {
        let request = fetchedResultsController.fetchRequest
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), name)
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate(self)
    }
}

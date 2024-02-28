//
//  CategoryTypeVCViewModel.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import UIKit

final class CategoryTypeVCViewModel{
    
    var categotyTypesBinding:  Binding<[CategoryTypeCellViewModel]>?
    
    private var trackerCategoryStore: TrackerCategoryStore
    
    private(set) var categoryType: [CategoryTypeCellViewModel] = [] {
        didSet {
            categotyTypesBinding?(categoryType)
        }
    }
  
    weak var delegate: NewTrackerVCViewModelCategoryTypeDelegate?
    var delegateViewModel = NewTrackerVCViewModel()
    
    convenience init() {
       let trackerCategoryStore = TrackerCategoryStore(
                context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            )
        self.init(trackerCategoryStore: trackerCategoryStore)
    }
    
    init( trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
        trackerCategoryStore.delegate = self
        categoryType = getСategoryTypeFromStore()
    }
    

    private func getСategoryTypeFromStore() -> [CategoryTypeCellViewModel]{
        let сategoryTypeCellViewModel = trackerCategoryStore.categoryTypes.map({ item in
            return CategoryTypeCellViewModel(id: item.objectID.uriRepresentation().absoluteString,
                                             categoryTitle: item.name ?? "")
        })
        return сategoryTypeCellViewModel
    }
}

extension CategoryTypeVCViewModel: TrackerCategoryStoreDelegate {
    func storeDidUpdate(_ store: TrackerCategoryStore) {
        categoryType = getСategoryTypeFromStore()
    }
}

extension CategoryTypeVCViewModel: NewCategoryTypeViewControllerDelegate {
    func addNewCategoryType(with categoryType: String) {
        let newCategoryType = TrackerCategory(name: categoryType,
                                              trackers: [])
        do {
            try trackerCategoryStore.addNewCategoryType(newCategoryType)
        } catch {
            print("error")
        }
    }
}

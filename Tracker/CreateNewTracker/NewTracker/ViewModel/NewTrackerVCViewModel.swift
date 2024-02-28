//
//  NewTrackerVCViewModel.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import Foundation

final class NewTrackerVCViewModel {
    
    var selectedCategory: NewTrackerObservable<CategoryNewTrackerViewCellViewModel>
    var weekDays: NewTrackerObservable<TimeSheetNewTrackerViewCellViewModel>
    var selectedEmoji: NewTrackerObservable<EmojiCollectionViewCellViewModel>
    var selectedColor: NewTrackerObservable<ColorsCollectionViewCellViewModel>
    
    init() {
        selectedCategory = NewTrackerObservable(value: CategoryNewTrackerViewCellViewModel(selectedCategory: ""))
        weekDays = NewTrackerObservable(value: TimeSheetNewTrackerViewCellViewModel(timeSheetDays: "", weekdays: []))
        selectedEmoji = NewTrackerObservable(value: EmojiCollectionViewCellViewModel(selectedEmoji: ""))
        selectedColor = NewTrackerObservable(value: ColorsCollectionViewCellViewModel(selectedColors: .clear))
    }
}

//MARK: - NewTrackerVCViewModelDelegate
extension NewTrackerVCViewModel: NewTrackerVCViewModelCategoryTypeDelegate {
    func getSelectedCategoryType(_ selectedCategory: String) {
        let newElement = CategoryNewTrackerViewCellViewModel(selectedCategory: selectedCategory)
        self.selectedCategory.value = newElement
    }
}

//MARK: - NewTrackerVCViewModelTimeSheetDelegate
extension NewTrackerVCViewModel: NewTrackerVCViewModelTimeSheetDelegate {
    func addTimeSheet(_ timeSheetDays: String, _ weekDays: [Int]) {
        let newElement = TimeSheetNewTrackerViewCellViewModel(timeSheetDays: timeSheetDays, weekdays: weekDays)
        self.weekDays.value? = newElement
    }
}



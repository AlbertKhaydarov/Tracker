//
//  NewTrackerVCViewModel.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import Foundation

final class NewTrackerVCViewModel {
    var selectedCategory: NewTrackerObservable<[CategoryNewTrackerViewCellViewModel]> = NewTrackerObservable(value: [])
    var weekDays: NewTrackerObservable<[TimeSheetNewTrackerViewCellViewModel]> = NewTrackerObservable(value: [])
    
}

//MARK: - NewTrackerVCViewModelDelegate
extension NewTrackerVCViewModel: NewTrackerVCViewModelDelegate {
    func getSelectedCategoryType(_ selectedCategory: String) {
        let newElement = CategoryNewTrackerViewCellViewModel(selectedCategory: selectedCategory)
        self.selectedCategory.value?.insert(newElement, at: 0)
        print(selectedCategory)
    }
}

//MARK: - NewTrackerVCViewModelTimeSheetDelegate
extension NewTrackerVCViewModel: NewTrackerVCViewModelTimeSheetDelegate {
    func addTimeSheet(_ timeSheetDays: String, _ weekDays: [Int]) {
        let newElement = TimeSheetNewTrackerViewCellViewModel(timeSheetDays: timeSheetDays, weekdays: weekDays)
        self.weekDays.value?.append(newElement)
    }
}


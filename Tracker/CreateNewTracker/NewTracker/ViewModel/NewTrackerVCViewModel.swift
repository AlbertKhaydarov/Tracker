//
//  NewTrackerVCViewModel.swift
//  Tracker
//
//  Created by Admin on 22.02.2024.
//

import UIKit

final class NewTrackerVCViewModel {
    
    var selectedCategory: NewTrackerObservable<CategoryNewTrackerViewCellViewModel>
    var weekDays: NewTrackerObservable<TimeSheetNewTrackerViewCellViewModel>
    var selectedEmoji: NewTrackerObservable<EmojiCollectionViewCellViewModel>
    var selectedColor: NewTrackerObservable<ColorsCollectionViewCellViewModel>
    
    var indexPathForSelectedEmoji: IndexPath?
    var indexPathForSelectedColor: IndexPath?
    
    var isTrackerNameEmpty = false
    var timeSheetIsEnable = false
    var categoryIsEnable = false
    var emojiSelectedIsEnable = false
    var colorSelectedIsEnable = false
    
    let colorSelection: [UIColor] = UIColor.colorSelection
    let emojiesCollection: [String] = String.emojiesCollection
    
    var typeEvent: TypeEvents?
    
    init() {
        selectedCategory = NewTrackerObservable(value: CategoryNewTrackerViewCellViewModel(selectedCategory: ""))
        weekDays = NewTrackerObservable(value: TimeSheetNewTrackerViewCellViewModel(timeSheetDays: "", weekdays: []))
        selectedEmoji = NewTrackerObservable(value: EmojiCollectionViewCellViewModel(selectedEmoji: ""))
        selectedColor = NewTrackerObservable(value: ColorsCollectionViewCellViewModel(selectedColors: .clear))
    }
    
    func handleEmojiSelection(at indexPath: IndexPath) {
        indexPathForSelectedEmoji = indexPath
        selectedEmoji.value?.selectedEmoji = emojiesCollection[indexPath.row]
        emojiSelectedIsEnable = true
    }
    func handleColorSelection(at indexPath: IndexPath) {
        indexPathForSelectedColor = indexPath
        selectedColor.value?.selectedColors = colorSelection[indexPath.row]
        colorSelectedIsEnable = true
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



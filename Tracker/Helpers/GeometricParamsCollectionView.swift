//
//  GeometricParamsCollectionView.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 23.01.2024.
//

import Foundation

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    let lineSpacingForSectionAt: CGFloat
    let lineSpacingForHeaderAndCard: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat, lineSpacingForSectionAt: CGFloat, lineSpacingForHeaderAndCard: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
        self.lineSpacingForSectionAt = lineSpacingForSectionAt
        self.lineSpacingForHeaderAndCard = lineSpacingForHeaderAndCard
    }
}

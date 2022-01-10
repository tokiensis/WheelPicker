//
//  FiniteWheelPickerDataSource.swift
//  WheelPicker
//
//  Created by tokiensis on 2022/01/10.
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI

public struct FiniteWheelPickerDataSource<T: Hashable>: WheelPickerDataSource {
    public var items: [T]
    public var initialSelection: T
    
    public func item(at offset: Int) -> T? {
        guard let initialSelectionIndex = items.firstIndex(of: initialSelection) else { return nil }
        let itemIndex = initialSelectionIndex + offset
        guard (0..<items.count).contains(itemIndex) else { return nil }
        return items[itemIndex]
    }
    
    public func offset(of item: T) -> Int? {
        guard let initialSelectionIndex = items.firstIndex(of: initialSelection),
              let itemIndex = items.firstIndex(of: item) else { return nil }
        return itemIndex - initialSelectionIndex
    }
    
    public func translationOffset(to item: T, origin: Int) -> Int {
        guard let offset = offset(of: item) else { return 0 }
        return offset - origin
    }
    
    public func limitDigreesTranslation(_ rawTranslation: Double, draggingStartOffset: Int?) -> Double {
        guard let initialSelectionIndex = items.firstIndex(of: initialSelection),
              let draggingStartOffset = draggingStartOffset else { return 0 }
        let draggingStartIndex = initialSelectionIndex + draggingStartOffset
        let maxTranslation = Double(draggingStartIndex * 18)
        let minTranslation = -Double(items.count - draggingStartIndex - 1) * 18
        return min(max(rawTranslation, minTranslation), maxTranslation)
    }
}

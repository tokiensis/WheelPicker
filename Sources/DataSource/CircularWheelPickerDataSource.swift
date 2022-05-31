//
//  CircularWheelPickerDataSource.swift
//  WheelPicker
//
//  Created by tokiensis on 2022/01/10.
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI

public struct CircularWheelPickerDataSource<T: Hashable>: WheelPickerDataSource {
    public var items: [T]
    public var initialSelection: T
    
    public init(items: [T], initialSelection: T) {
        self.items = items
        self.initialSelection = initialSelection
    }
    
    public func item(at offset: Int) -> T? {
        guard let initialSelectionIndex = items.firstIndex(of: initialSelection) else { return nil }
        let itemIndex = initialSelectionIndex + offset
        if itemIndex < 0 {
            return items[(items.count + (itemIndex % items.count)) % items.count]
        } else {
            return items[itemIndex % items.count]
        }
    }
    
    public func offset(of item: T) -> Int? {
        guard let initialSelectionIndex = items.firstIndex(of: initialSelection),
              let itemIndex = items.firstIndex(of: item) else { return nil }
        return itemIndex - initialSelectionIndex
    }
    
    public func translationOffset(to item: T, origin: Int) -> Int {
        guard let offset = offset(of: item) else { return 0 }
        let minimumOriginOffset = origin % items.count
        let translation = offset - minimumOriginOffset
        if abs(translation) > items.count / 2 {
            return (items.count - abs(translation)) * (translation > 0 ? -1 : 1)
        } else {
            return translation
        }
    }
    
    public func limitDigreesTranslation(_ rawTranslation: Double, draggingStartOffset: Int?) -> Double {
        return rawTranslation
    }
    
    public func maxTranslation(draggingStartOffset: Int?) -> Double {
        .infinity
    }
    
    public func minTranslation(draggingStartOffset: Int?) -> Double {
        -.infinity
    }
}

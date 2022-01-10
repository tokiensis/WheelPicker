//
//  DateWheelPickerDataSource.swift
//  WheelPicker
//
//  Created by tokiensis on 2022/01/10.
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI

public struct DateWheelPickerDataSource: WheelPickerDataSource {
    public var initialSelection: Date
    private let oneDaySeconds = 24 * 60 * 60
    
    public func item(at offset: Int) -> Date? {
        initialSelection.advanced(by: TimeInterval(oneDaySeconds * offset))
    }
    
    public func offset(of item: Date) -> Int? {
        Int(initialSelection.distance(to: item)) / oneDaySeconds
    }
    
    public func translationOffset(to item: Date, origin: Int) -> Int {
        guard let offset = offset(of: item) else { return 0 }
        return offset - origin
    }
    
    public func limitDigreesTranslation(_ rawTranslation: Double, draggingStartOffset: Int?) -> Double {
        return rawTranslation
    }
}

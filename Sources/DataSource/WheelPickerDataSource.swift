//
//  WheelPickerDataSource.swift
//  WheelPicker
//
//  Created by tokiensis on 2022/01/10.
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI

public protocol WheelPickerDataSource {
    associatedtype T: Hashable
    var initialSelection: T { get set }
    func item(at offset: Int) -> T?
    func offset(of item: T) -> Int?
    func translationOffset(to item: T, origin: Int) -> Int
    func limitDigreesTranslation(_ rawTranslation: Double, draggingStartOffset: Int?) -> Double
}

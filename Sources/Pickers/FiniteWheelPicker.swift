//
//  FiniteWheelPicker.swift
//  WheelPicker
//
//  Created by tokiensis on 2022/01/10.
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI

public struct FiniteWheelPicker<V: Hashable, Label: View>: View {
    @Binding var selection: V
    @State private var dataSource: FiniteWheelPickerDataSource<V>
    var label: (V?) -> Label
    
    public init(selection: Binding<V>, items: [V], @ViewBuilder label: @escaping (V?) -> Label) {
        let dataSource = FiniteWheelPickerDataSource(items: items, initialSelection: selection.wrappedValue)
        _selection = selection
        _dataSource = State(initialValue: dataSource)
        self.label = label
    }
    
    public var body: some View {
        WheelPicker(selection: $selection, dataSource: dataSource, label: label)
            .background(SelectedPositionBackground())
            .overlay(GradientOverlay())
    }
}

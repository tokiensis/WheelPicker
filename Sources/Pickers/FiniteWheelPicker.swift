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
    var accessibilityText: ((V) -> String)?
    var label: (V?) -> Label
    
    public init(selection: Binding<V>, items: [V], accessibilityText: ((V) -> String)? = nil, @ViewBuilder label: @escaping (V?) -> Label) {
        let dataSource = FiniteWheelPickerDataSource(items: items, initialSelection: selection.wrappedValue)
        _selection = selection
        _dataSource = State(initialValue: dataSource)
        self.accessibilityText = accessibilityText
        self.label = label
    }
    
    public var body: some View {
        WheelPicker(selection: $selection, dataSource: dataSource, label: label)
            .accessibilityElement()
            .accessibilityValue(accessibilityText?(selection) ?? "")
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    guard let offset = dataSource.offset(of: selection),
                          let newValue = dataSource.item(at: offset + 1) else { return }
                    selection = newValue
                case .decrement:
                    guard let offset = dataSource.offset(of: selection),
                          let newValue = dataSource.item(at: offset - 1) else { return }
                    selection = newValue
                @unknown default:
                    return
                }
            }
            .background(SelectedPositionBackground())
    }
}

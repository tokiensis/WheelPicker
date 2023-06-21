//
//  DateWheelPicker.swift
//  WheelPicker
//
//  Created by tokiensis on 2022/01/10.
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI

public struct DateWheelPicker: View {
    @Binding var selection: Date
    @State private var dateSelection: Date
    @State private var hourSelection: Int
    @State private var minuteSelection: Int
    @State private var datePickerDataSource: DateWheelPickerDataSource
    @State private var hourPickerDataSource: CircularWheelPickerDataSource<Int>
    @State private var minutePickerDataSource: CircularWheelPickerDataSource<Int>
    private let dateFormatter = DateFormatter()
    private let dateColorSelector: ((Date) -> Color?)?
    
    public init(selection: Binding<Date>, dateFormatTemplate: String = "MMMdeee", dateColorSelector: ((Date) -> Color?)? = nil) {
        let date = DateWheelPicker.timeRemovedDate(from: selection.wrappedValue)
        let hour = DateWheelPicker.hour(from: selection.wrappedValue)
        let minute = DateWheelPicker.minute(from: selection.wrappedValue)
        
        _selection = selection
        _dateSelection = State(initialValue: date)
        _hourSelection = State(initialValue: hour)
        _minuteSelection = State(initialValue: minute)
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: dateFormatTemplate, options: 0, locale: .current)
        self.dateColorSelector = dateColorSelector
        
        let dateDataSource = DateWheelPickerDataSource(initialSelection: date)
        _datePickerDataSource = State(initialValue: dateDataSource)
        
        let hours = (0...23).map { $0 }
        let hourDateSource = CircularWheelPickerDataSource(items: hours, initialSelection: hour)
        _hourPickerDataSource = State(initialValue: hourDateSource)
        
        let minutes = (0...59).map { $0 }
        let minuteDateSource = CircularWheelPickerDataSource(items: minutes, initialSelection: minute)
        _minutePickerDataSource = State(initialValue: minuteDateSource)
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            WheelPicker(selection: $dateSelection, dataSource: datePickerDataSource) {
                Text(dateText(from: $0))
                    .foregroundColor(dateTextColor(of: $0))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(width: 160)
            .accessibilityElement()
            .accessibilityValue(dateText(from: dateSelection))
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    guard let offset = datePickerDataSource.offset(of: dateSelection),
                          let newValue = datePickerDataSource.item(at: offset + 1) else { return }
                    dateSelection = newValue
                case .decrement:
                    guard let offset = datePickerDataSource.offset(of: dateSelection),
                          let newValue = datePickerDataSource.item(at: offset - 1) else { return }
                    dateSelection = newValue
                @unknown default:
                    return
                }
            }
            
            WheelPicker(selection: $hourSelection, dataSource: hourPickerDataSource) {
                Text(hourText(from: $0))
                    .frame(maxWidth: .infinity)
            }
            .frame(width: 60)
            .accessibilityElement()
            .accessibilityValue(hourText(from: hourSelection))
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    guard let offset = hourPickerDataSource.offset(of: hourSelection),
                          let newValue = hourPickerDataSource.item(at: offset + 1) else { return }
                    hourSelection = newValue
                case .decrement:
                    guard let offset = hourPickerDataSource.offset(of: hourSelection),
                          let newValue = hourPickerDataSource.item(at: offset - 1) else { return }
                    hourSelection = newValue
                @unknown default:
                    return
                }
            }
            
            WheelPicker(selection: $minuteSelection, dataSource: minutePickerDataSource) {
                Text(minuteText(from: $0))
            }
            .frame(width: 60)
            .padding(.trailing, 20)
            .accessibilityElement()
            .accessibilityValue(minuteText(from: minuteSelection))
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    guard let offset = minutePickerDataSource.offset(of: minuteSelection),
                          let newValue = minutePickerDataSource.item(at: offset + 1) else { return }
                    minuteSelection = newValue
                case .decrement:
                    guard let offset = minutePickerDataSource.offset(of: minuteSelection),
                          let newValue = minutePickerDataSource.item(at: offset - 1) else { return }
                    minuteSelection = newValue
                @unknown default:
                    return
                }
            }
        }
        .background(SelectedPositionBackground())
        .onChange(of: selection) { date in
            dateSelection = DateWheelPicker.timeRemovedDate(from: date)
            hourSelection = DateWheelPicker.hour(from: date)
            minuteSelection = DateWheelPicker.minute(from: date)
        }
        .onChange(of: dateSelection) { _ in
            updateBinding()
        }
        .onChange(of: hourSelection) { _ in
            updateBinding()
        }
        .onChange(of: minuteSelection) { _ in
            updateBinding()
        }
    }
}

private extension DateWheelPicker {
    static func timeRemovedDate(from date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        guard let date = Calendar.current.date(from: components) else {
            fatalError()
        }
        return date
    }
    
    static func hour(from date: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: date)
        guard let hour = components.hour else {
            fatalError()
        }
        return hour
    }
    
    static func minute(from date: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: date)
        guard let minute = components.minute else {
            fatalError()
        }
        return minute
    }
    
    func dateText(from date: Date?) -> String {
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
    
    func dateTextColor(of date: Date?) -> Color? {
        guard let date = date else { return nil }
        return dateColorSelector?(date)
    }
    
    func hourText(from hour: Int?) -> String {
        guard let hour = hour else { return "" }
        return String(hour)
    }
    
    func minuteText(from minute: Int?) -> String {
        guard let minute = minute else { return "" }
        return String(format: "%02d", minute)
    }
    
    func updateBinding() {
        selection = dateSelection.advanced(by: TimeInterval(hourSelection * 3600 + minuteSelection * 60))
    }
}

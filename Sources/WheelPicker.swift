//
//  WheelPicker.swift
//  WheelPicker
//
//  Created by tokiensis on 2022/01/10.
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI

public struct WheelPicker<DataSource: WheelPickerDataSource, Label: View>: View {
    public var selection: Binding<DataSource.T>
    public var dataSource: DataSource
    @ViewBuilder public var label: (DataSource.T?) -> Label
    
    @State private var translationHeight: CGFloat = .zero
    @State private var selectionOffset: Int = 0
    @State private var draggingStartOffset: Int?
    @State private var timer: Timer?
    @State private var timerRepeatCount = 0
    @State private var timerUpdateCount = 0
    private let height: CGFloat = 180
    private let fontSize: CGFloat = 22
    
    public init(selection: Binding<DataSource.T>, dataSource: DataSource, @ViewBuilder label: @escaping (DataSource.T?) -> Label) {
        self.selection = selection
        self.dataSource = dataSource
        self.label = label
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            ForEach(0..<9, id: \.self) { index in
                label(item(at: index, translationHeight: translationHeight))
                    .font(.system(size: fontSize))
                    .opacity(opacity(at: index, translationHeight: translationHeight))
                    .rotation3DEffect(
                        .degrees(rotationDigrees(at: index, translationHeight: translationHeight)),
                        axis: (x: 1, y: 0, z: 0),
                        anchor: .center,
                        anchorZ: 15,
                        perspective: 0
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: itemHeight(at: index, translationHeight: translationHeight))
            }
        }
        .offset(x: 0, y: itemsHeightDifference(translationHeight: translationHeight) * (translationHeight > 0 ? 2.0 : -2.0))
        .frame(height: height)
        .clipped()
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if timer?.isValid ?? false {
                        timer?.invalidate()
                        self.timer = nil
                        updateSelectionBinding()
                        draggingStartOffset = nil
                        translationHeight = .zero
                        return
                    }
                    if translationHeight == .zero {
                        draggingStartOffset = selectionOffset
                    }
                    translationHeight = value.translation.height
                    updateSelection(from: value.translation.height)
                }
                .onEnded { value in
                    let initialTranslation = translationHeight
                    let maxAnimatingTranslation = height * 3
                    let wheelStopResolution = height / 10
                    let adjustedEndTranslation = round(value.predictedEndTranslation.height / wheelStopResolution) * wheelStopResolution
                    var animatingTranslation = min(max(adjustedEndTranslation - initialTranslation, -maxAnimatingTranslation), maxAnimatingTranslation)
                    if abs(animatingTranslation) < wheelStopResolution * 2.5 {
                        let translationFromCurrentSelection = initialTranslation.truncatingRemainder(dividingBy: wheelStopResolution)
                        if translationFromCurrentSelection == 0 {
                            animatingTranslation = 0
                        } else if abs(translationFromCurrentSelection) < wheelStopResolution / 2 {
                            animatingTranslation = -translationFromCurrentSelection
                        } else {
                            animatingTranslation = (wheelStopResolution - abs(translationFromCurrentSelection)) * (translationFromCurrentSelection > 0 ? 1 : -1)
                        }
                    }
                    animate(animatingTranslation: animatingTranslation)
                }
        )
        .onChange(of: selection.wrappedValue) { value in
            guard draggingStartOffset == nil else { return }
            let translationOffset = dataSource.translationOffset(to: value, origin: selectionOffset)
            guard translationOffset != 0 else { return }
            let wheelStopResolution = height / 10
            let translationHeight = -CGFloat(translationOffset) * wheelStopResolution
            draggingStartOffset = selectionOffset
            animate(animatingTranslation: translationHeight)
        }
    }
}

private extension WheelPicker {
    func item(at index: Int, translationHeight: CGFloat) -> DataSource.T? {
        let itemOffset: Int
        let offset = index - 4
        let digreesOffset = digreesTranslation(from: translationHeight)
        if let draggingStartOffset = draggingStartOffset {
            let indexOffset = -Int(digreesOffset / 18)
            let selectionOffset = draggingStartOffset + indexOffset
            itemOffset = selectionOffset + offset
        } else {
            itemOffset = selectionOffset + offset
        }
        return dataSource.item(at: itemOffset)
    }
    
    func rotationDigrees(at index: Int, translationHeight: CGFloat) -> Double {
        let digrees = Double((index + 1) * 18) - 90 // -90 ~ 90
        let offset = digreesTranslation(from: translationHeight).truncatingRemainder(dividingBy: 18)
        return (360 + digrees + offset).truncatingRemainder(dividingBy: 360)
    }
    
    func itemHeight(at index: Int, translationHeight: CGFloat) -> CGFloat {
        let digrees = Double((index + 1) * 18) - 90 // -90 ~ 90
        let offset = digreesTranslation(from: translationHeight).truncatingRemainder(dividingBy: 18)
        let ratio = (90 - abs(digrees + offset)) / 90
        return max(fontSize * CGFloat(ratio), 0)
    }
    
    func opacity(at index: Int, translationHeight: CGFloat) -> Double {
        let digrees = Double((index + 1) * 18) - 90
        let offset = digreesTranslation(from: translationHeight).truncatingRemainder(dividingBy: 18)
        let translatedDigrees = abs(digrees + offset)
        if translatedDigrees < 20 {
            return (translatedDigrees / -40) + 1
        } else {
            return (90 - translatedDigrees) / 140
        }
    }
    
    func digreesTranslation(from translationHeight: CGFloat) -> Double {
        let translation = Double(translationHeight / height) * 180
        return dataSource.limitDigreesTranslation(translation, draggingStartOffset: draggingStartOffset)
    }
    
    // 回転中にitemの高さが減少するので、回転体全体の高さが変わらないように差分を加えて補正する
    func itemsHeightDifference(translationHeight: CGFloat) -> CGFloat {
        let defaultItemsHeight = (0..<9).reduce(.zero) {
            $0 + itemHeight(at: $1, translationHeight: 0)
        }
        let itemsHeight = (0..<9).reduce(.zero) {
            $0 + itemHeight(at: $1, translationHeight: translationHeight)
        }
        return defaultItemsHeight - itemsHeight
    }
    
    func updateSelection(from translationHeight: CGFloat) {
        let digreesOffset = digreesTranslation(from: translationHeight)
        if let draggingStartOffset = draggingStartOffset {
            let indexOffset = -Int(round(digreesOffset / 18))
            selectionOffset = draggingStartOffset + indexOffset
        }
    }
    
    func updateSelectionBinding() {
        guard let newSelectionItem = dataSource.item(at: selectionOffset) else { return }
        selection.wrappedValue = newSelectionItem
    }
    
    func animate(animatingTranslation: CGFloat) {
        guard animatingTranslation != 0 else {
            draggingStartOffset = nil
            translationHeight = .zero
            return
        }
        let frameLate: Double = 120
        let deceleration = -height / CGFloat(frameLate * frameLate)
        let decelerateFrames = Int(round(sqrt(abs(animatingTranslation / -deceleration))))
        let initialSpeed = -deceleration * CGFloat(decelerateFrames)
        
        let maxTranslationLimit = dataSource.maxTranslation(draggingStartOffset: draggingStartOffset)
        let minTranslationLimit = dataSource.minTranslation(draggingStartOffset: draggingStartOffset)
        let translationRange = minTranslationLimit...maxTranslationLimit
        
        timerRepeatCount = decelerateFrames + abs(Int((animatingTranslation / initialSpeed) / 2))
        timerUpdateCount = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1 / frameLate, repeats: true) { timer in
            guard timerUpdateCount < timerRepeatCount, translationRange.contains(translationHeight) else {
                timer.invalidate()
                self.timer = nil
                updateSelectionBinding()
                draggingStartOffset = nil
                translationHeight = .zero
                return
            }
            let remainingFrames = timerRepeatCount - timerUpdateCount
            if remainingFrames >= decelerateFrames {
                translationHeight += CGFloat(initialSpeed) * (animatingTranslation > 0 ? 1 : -1)
            } else {
                let translation = initialSpeed * CGFloat(decelerateFrames - remainingFrames) + ((deceleration * pow(CGFloat(decelerateFrames - remainingFrames), 2)) / 2)
                let prevFrameTranslation = initialSpeed * CGFloat(decelerateFrames - remainingFrames - 1) + ((deceleration * pow(CGFloat(decelerateFrames - remainingFrames - 1), 2)) / 2)
                translationHeight += (translation - prevFrameTranslation) * (animatingTranslation > 0 ? 1 : -1)
            }
            updateSelection(from: translationHeight)
            timerUpdateCount += 1
        }
    }
}

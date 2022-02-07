//
//  SelectedPositionBackground.swift
//  WheelPicker
//
//  Created by tokiensis on 2022/01/10.
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI

public struct SelectedPositionBackground: View {
    var color: Color {
#if os(iOS)
        return Color(.systemGray5)
#elseif os(macOS)
        return Color(NSColor.unemphasizedSelectedContentBackgroundColor)
#endif
    }
    
    public init() {}
    
    public var body: some View {
        color
            .opacity(0.8)
            .cornerRadius(4)
            .frame(height: 32)
    }
}

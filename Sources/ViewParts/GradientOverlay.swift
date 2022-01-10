//
//  GradientOverlay.swift
//  WheelPicker
//
//  Created by tokiensis on 2022/01/10.
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI

public struct GradientOverlay: View {
    var color: Color {
#if os(iOS)
        return Color(.systemBackground)
#elseif os(macOS)
        return Color(NSColor.controlBackgroundColor)
#endif
    }
    
    public var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: color.opacity(0.9), location: 0.0),
                .init(color: color.opacity(0.5), location: 0.4),
                .init(color: color.opacity(0.0), location: 0.42),
                .init(color: color.opacity(0.0), location: 0.58),
                .init(color: color.opacity(0.5), location: 0.6),
                .init(color: color.opacity(0.9), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .allowsHitTesting(false)
    }
}

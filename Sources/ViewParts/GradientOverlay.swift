//
//  GradientOverlay.swift
//  WheelPicker
//
//  Created by tokiensis on 2022/01/10.
//  Copyright © 2022 Wataku-City. All rights reserved.
//

import SwiftUI

public struct GradientOverlay: View {
    public var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(.systemBackground).opacity(0.9), location: 0.0),
                .init(color: Color(.systemBackground).opacity(0.5), location: 0.4),
                .init(color: Color(.systemBackground).opacity(0.0), location: 0.42),
                .init(color: Color(.systemBackground).opacity(0.0), location: 0.58),
                .init(color: Color(.systemBackground).opacity(0.5), location: 0.6),
                .init(color: Color(.systemBackground).opacity(0.9), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

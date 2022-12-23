//
//  Buttons.swift
//  iosApp
//
//  Created by didi on 12/23/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct BasicButtonCircle: ButtonStyle {
    var bgColor: Color
    var secondaryColor: Color
//    var selectedOption : Bool?
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(
                ZStack {
                    Circle()
                        .fill(configuration.isPressed ? secondaryColor : bgColor )
//                        .fonzShadow()
                        .overlay(
                        Circle().stroke(secondaryColor, lineWidth: 3)
                    )
                }
        )
            .animation(.spring())
    }
}

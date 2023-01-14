//
//  Font.swift
//  iosApp
//
//  Created by didi on 1/13/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import SwiftUI

// text boxes

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("MuseoSans-700", size: 56))
            .foregroundColor(Color(.systemGray5))
            .multilineTextAlignment(.center)
            .padding(.horizontal)

    }
}
struct Heading: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("MuseoSans-700", size: 40))
            .foregroundColor(Color(.systemGray5))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 10)

    }
}
struct Subheading: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("MuseoSans-500", size: 24))
            .foregroundColor(Color(.systemGray5))
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}
struct ParagraphOne: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("MuseoSans-300", size: 24))
            .foregroundColor(Color(.systemGray5))
            .multilineTextAlignment(.center)
//            .padding(.horizontal)
    }
}
struct ParagraphTwo: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("MuseoSans-300", size: 18))
            .foregroundColor(Color(.systemGray5))
//            .padding(.horizontal)
    }
}
struct ButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("MuseoSans-300", size: 16))
            .foregroundColor(Color(.systemGray5))
//            .padding(.horizontal)
    }
}
struct RoundButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("MuseoSans-300", size: 20))
            .foregroundColor(Color(.systemGray5))
            .multilineTextAlignment(.center)
//            .padding(.horizontal)
    }
}
struct ParagraphThree: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("MuseoSans-100", size: 12))
    }
}

//struct InsideTextView: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(Font.custom("MuseoSans-100", size: 16))
//            .padding(50)
//
//    }
//}

// extension so fonts can be used as modifiers
extension View {
    func heading() -> some View {
        self.modifier(Heading())
    }
    func subheading() -> some View {
        self.modifier(Subheading())
    }
    func paragraphOne() -> some View {
        self.modifier(ParagraphOne())
    }
    func paragraphTwo() -> some View {
        self.modifier(ParagraphTwo())
    }
    func buttonText() -> some View {
        self.modifier(ButtonText())
    }
    func roundButtonText() -> some View {
        self.modifier(RoundButtonText())
    }
    func paragraphThree() -> some View {
        self.modifier(ParagraphThree())
    }
}

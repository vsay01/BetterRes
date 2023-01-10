//
//  TitleViewModifier.swift
//  GuessTheFlag
//
//  Created by vsay on 1/4/23.
//

import SwiftUI

struct ResultViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundStyle(.blue)
            .padding()
    }
}

extension View {
    func resultStyle() -> some View {
        modifier(ResultViewModifier())
    }
}

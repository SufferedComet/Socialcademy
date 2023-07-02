//
//  PrimaryButtonStyle.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 7/1/23.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        Group {
            if isEnabled {
                configuration.label
            } else {
                ProgressView()
            }
        }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(10)
            .animation(.default, value: isEnabled)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

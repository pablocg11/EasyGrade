//
//  ConfirmationNotification.swift
//  EasyGrade
//
//  Created by Pablo Castro on 10/1/25.
//

import SwiftUI
import Lottie

struct ConfirmationNotification: View {
    var titleNotification: String
    var messageNotification: String
    var error: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            LottieView(animation: error ? .named("alert_animation.json") : .named("confirmation_animation.json"))
                .playing(loopMode: .playOnce)
                .frame(maxWidth: 100, maxHeight: 100)
            
            MainText(text: titleNotification,
                     font: .headline,
                     fontWeight: .semibold,
                     textAlignment: .center)
            
            MainText(text: messageNotification,
                     textColor: .gray,
                     font: .callout,
                     textAlignment: .center)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

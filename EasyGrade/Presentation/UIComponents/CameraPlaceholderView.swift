//
//  cameraPlaceholderView.swift
//  EasyGrade
//
//  Created by Pablo Castro on 10/1/25.
//

import SwiftUI

struct CameraPlaceholderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.blue, lineWidth: 3)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                )
                .padding()
                .padding(.vertical, 50)
            VStack(spacing: 100) {
                MainText(
                    text: "Coloque el examen aquí",
                    font: .title3,
                    fontWeight: .semibold
                )
                MainText(
                    text: "Asegúrese de que el examen esté completamente visible y dentro del marco",
                    font: .footnote,
                    fontWeight: .regular,
                    textAlignment: .center
                )
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    CameraPlaceholderView()
}

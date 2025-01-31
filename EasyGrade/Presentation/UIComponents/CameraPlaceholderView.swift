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
                .padding(10)
            VStack(spacing: 80) {
                MainText(
                    text: "Coloque la información a escanear aquí",
                    font: .title3,
                    fontWeight: .semibold,
                    textAlignment: .center
                )
                MainText(
                    text: "Asegúrese de que el contenido esté completamente visible",
                    textColor: .white,
                    font: .footnote,
                    fontWeight: .regular,
                    textAlignment: .center
                )
            }
            .padding(30)
        }
        .frame(maxHeight: 250)
    }
}

#Preview {
    CameraPlaceholderView()
}

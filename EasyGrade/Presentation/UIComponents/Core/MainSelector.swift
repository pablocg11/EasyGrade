//
//  MainSelector.swift
//  EasyGrade
//
//  Created by Pablo Castro on 30/1/25.
//

import SwiftUI

struct MainSelector: View {
    var placeholder: String
    var students: [Student]
    @Binding var selectedStudent: Student?
    
    var body: some View {
        Menu {
            ForEach(students, id: \.id) { student in
                Button(action: {
                    selectedStudent = student
                }) {
                    Text(student.name)
                }
            }
        } label: {
            HStack {
                Text(selectedStudent?.name ?? placeholder)
                    .foregroundColor(selectedStudent == nil ? .gray : Color("AppPrimaryColor"))
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color("AppPrimaryColor"))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 5).stroke(Color("AppSecondaryColor"), lineWidth: 1))
            .background(Color("AppSecondaryColor"))
            .cornerRadius(5)
        }
    }
}

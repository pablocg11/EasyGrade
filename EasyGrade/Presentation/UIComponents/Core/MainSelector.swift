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
            ForEach(sortedStudents, id: \.id) { student in
                Button(action: {
                    selectedStudent = student
                }) {
                    Text("\(student.name) \(student.lastName)")
                }
            }
        } label: {
            HStack {
                if let student = selectedStudent {
                    Text("\(student.name) \(student.lastName)")
                        .foregroundColor(selectedStudent == nil ? .gray : Color("AppPrimaryColor"))
                } else {
                    Text(placeholder)
                        .foregroundColor(.gray)
                }
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
    
    private var sortedStudents: [Student] {
        students.sorted { $0.lastName < $1.lastName }
    }
}

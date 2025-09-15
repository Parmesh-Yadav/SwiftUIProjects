//
//  AddActivityView.swift
//  habit-tracking
//
//  Created by Parmesh Yadav on 15/09/25.
//

import SwiftUI

struct AddActivityView: View {
    @EnvironmentObject var activities: Activities
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                
                TextField("Description", text: $description)
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !title.isEmpty {
                            activities.add(title: title, description: description)
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddActivityView()
        .environmentObject(Activities())
}

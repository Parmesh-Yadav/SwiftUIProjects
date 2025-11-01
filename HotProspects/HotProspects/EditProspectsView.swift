//
//  EditProspectsView.swift
//  HotProspects
//
//  Created by Parmesh Yadav on 01/11/25.
//

import SwiftUI
import SwiftData

struct EditProspectsView: View {
    @Bindable var prospect: Prospect
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $prospect.name)
                
                TextField("Email", text: $prospect.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
        }
        .navigationTitle("Edit Prospect")
        .toolbar {
            Button("Done") {
                dismiss()
            }
        }
    }
}

#Preview {
    let sample = Prospect(name: "John Doe", email: "john@example.com", isContacted: false)
    EditProspectsView(prospect: sample)
}

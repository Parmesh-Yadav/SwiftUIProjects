//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Parmesh Yadav on 17/09/25.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var email = ""
    
    var disabledForm: Bool {
        username.count < 5 || email.count < 5
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                
                TextField("Email", text: $email)
            }
            
            Section {
                Button("Create Account") {
                    print("Creating Account with username: \(username), email: \(email)")
                }
            }
            .disabled(disabledForm)
        }
    }
}

#Preview {
    ContentView()
}

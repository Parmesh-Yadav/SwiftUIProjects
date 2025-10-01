//
//  DetailView.swift
//  Day60Challenge
//
//  Created by Parmesh Yadav on 01/10/25.
//

import SwiftUI

struct DetailView: View {
    let user: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(user.name)
                    .font(.largeTitle.bold())
                
                Text("\(user.age) years old ; \(user.company)")
                    .font(.headline)
                
                Text(user.email)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                Text("About")
                    .font(.title2.bold())
                
                Text(user.about)
                
                Divider()
                
                Text("Friends")
                    .font(.title2.bold())
                
                ForEach(user.friends){ friend in
                    Text(friend.name);
                }
            }
            .padding()
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

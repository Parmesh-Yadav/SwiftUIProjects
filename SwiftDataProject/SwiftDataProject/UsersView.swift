//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by Parmesh Yadav on 29/09/25.
//

import SwiftUI
import SwiftData

struct UsersView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    
    var body: some View {
        List(users) { user in
            HStack {
                Text(user.name)
                
                Spacer()
                
                Text(String(user.jobs.count))
                    .fontWeight(.black)
                    .padding(.horizontal,10)
                    .padding(.vertical,5)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
        .onAppear(perform: addSample)
    }
    
    init(minJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User>{ user in
            user.joinDate >= minJoinDate
        }, sort: sortOrder)
    }
    
    func addSample() {
        let user = User(name: "Parmesh Yadav", city: "Delhi", joinDate: .now)
        let job1 = Job(name: "JIO", priority: 0)
        let job2 = Job(name: "HCL", priority: 1)
        
        modelContext.insert(user)
        user.jobs.append(job1)
        user.jobs.append(job2)
    }
}

#Preview {
    UsersView(minJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}

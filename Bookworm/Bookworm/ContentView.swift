//
//  ContentView.swift
//  Bookworm
//
//  Created by Parmesh Yadav on 23/09/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var books: [Book]
    @State private var showAddScreen = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add book", systemImage: "plus") {
                        showAddScreen.toggle()
                    }
                }
            }
            .sheet(isPresented: $showAddScreen) {
                AddBookView()
            }
        }
    }
}

#Preview {
    ContentView()
}

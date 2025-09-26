//
//  DetailView.swift
//  Bookworm
//
//  Created by Parmesh Yadav on 25/09/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var showDeleteAlert = false
    
    let book: Book
    private var displayedTitle: String { book.title.isEmpty ? "unknown title" : book.title}
    private var displayedAuthor: String { book.author.isEmpty ? "unknown author" : book.author}
    private var displayedGenre: String { book.genre.isEmpty ? "unknown genre" : book.genre}
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre)
                    .resizable()
                    .scaledToFit()
                
                Text(displayedGenre.uppercased())
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                    .offset(x: -5, y: -5)
            }
            
            Text(displayedAuthor)
                .font(.title)
                .foregroundStyle(.secondary)
            
            Text(book.date, format: .dateTime.day().month().year().hour().minute())
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.bottom, 4)
            
            Text(book.review)
                .padding()
            
            RatingView(rating: .constant(book.rating))
                .font(.largeTitle)
        }
        .navigationTitle(displayedTitle)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete Book", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button("Delete this book", systemImage: "trash") {
                showDeleteAlert = true
            }
        }
    }
    
    func genreImage(for genre: String) -> Image {
        let knownGenres = ["Fantasy", "Romance", "Mystery", "Science Fiction", "Horror"]
        if knownGenres.contains(genre) { return Image(genre)}
        else { return Image(systemName: "book.closed")}
    }
    
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try? ModelContainer(for: Book.self, configurations: config)
    let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "Great book", rating: 4)
    
    if let container {
        DetailView(book: example)
            .modelContainer(container)
    } else {
        Text("Failed to create preview")
    }
}

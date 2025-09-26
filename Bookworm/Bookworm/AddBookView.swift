//
//  AddBookView.swift
//  Bookworm
//
//  Created by Parmesh Yadav on 24/09/25.
//

import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = Self.genres.first ?? ""
    @State private var review = ""
    
    static let genres = ["Fantasy", "Romance", "Mystery", "Science Fiction", "Horror"]
    
    private var isFormValid: Bool {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let a = author.trimmingCharacters(in: .whitespacesAndNewlines)
        return !t.isEmpty && !a.isEmpty && !genre.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    
                    TextField("Author's Name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(AddBookView.genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                }
                
                Section {
                    Button("Save") {
                        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        let cleanAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
                        let cleanReview = review.trimmingCharacters(in: .whitespacesAndNewlines)
                        let newBook = Book(title: cleanTitle, author: cleanAuthor, genre: genre, review: cleanReview, rating: rating)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.6)
                }
            }
            .navigationTitle("Add Book")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.borderless)
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
}

#Preview {
    AddBookView()
}

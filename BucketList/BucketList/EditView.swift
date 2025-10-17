//
//  EditView.swift
//  BucketList
//
//  Created by Parmesh Yadav on 14/10/25.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: ViewModel
    
    var onSave: (Location) -> Void
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageID) { page in
                            VStack(alignment: .leading) {
                                Text(page.title)
                                    .font(.headline)
                                Text(page.description)
                                    .italic()
                            }
                        }
                    case .failed:
                        Text("Please try again.")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar {
                Button("Save") {
                    var newLocation = viewModel.location
                    newLocation.id = UUID()
                    newLocation.name = viewModel.name
                    newLocation.description = viewModel.description
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }
    
}

#Preview {
    EditView(location: .example) { _ in }
}

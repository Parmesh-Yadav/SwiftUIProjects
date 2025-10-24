//
//  AddView.swift
//  day77-challenge
//
//  Created by Parmesh Yadav on 22/10/25.
//

import SwiftUI
import PhotosUI
import CoreLocation

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var data: DataController
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var uiImage: UIImage?
    @State private var name: String = ""
    @State private var savingError: String?
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Select photo")
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                await loadSelectedImage()
                            }
                        }
                        
                        if let uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 250)
                                .clipShape(.capsule)
                        }
                    }
                }
                
                Section("Name") {
                    TextField("Enter name", text: $name)
                        .autocorrectionDisabled()
                }
                
                if let savingError {
                    Text("Error: \(savingError)")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Add Person")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(imageData == nil || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                locationFetcher.start()
            }
        }
    }
    
    func loadSelectedImage() async {
        guard let selectedItem else { return }
        
        do {
            if let data = try await selectedItem.loadTransferable(type: Data.self) {
                if let image = UIImage(data: data) {
                    if let jpegData = image.jpegData(compressionQuality: 0.9) {
                        self.imageData = jpegData
                        self.uiImage = image
                    } else {
                        self.imageData = data
                        self.uiImage = image
                    }
                } else {
                    self.imageData = data
                    self.uiImage = UIImage(data: data)
                }
            }
        } catch {
            print("Failed to load image: \(error.localizedDescription)")
        }
    }
    
    func save() {
        guard let imageData else {
            savingError = "No image selected"
            return
        }
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let location = locationFetcher.lastKnownLocation
        
        Task {
            do {
                try data.add(name: trimmedName, imageData: imageData, latitude: location?.latitude, longitude: location?.longitude)
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    savingError = "Failed to save: \(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    AddView()
}

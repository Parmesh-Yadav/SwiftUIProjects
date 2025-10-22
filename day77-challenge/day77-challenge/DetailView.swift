//
//  DetailView.swift
//  day77-challenge
//
//  Created by Parmesh Yadav on 22/10/25.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var data: DataController
    @Environment(\.dismiss) var dismiss
    
    let item: PersonPhoto
    
    var body: some View {
        NavigationView {
            VStack {
                if let imageData = data.imageData(for: item.imageFilename),
                   let uiImage = UIImage(data: imageData) {
                    ScrollView([.vertical,.horizontal]) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                } else {
                    Image("Image not found")
                        .foregroundStyle(.secondary)
                        .padding()
                }
                
                Text(item.name)
                    .font(.title2)
                    .padding(.top,8)
                
                Spacer()
            }
            .navigationTitle(item.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

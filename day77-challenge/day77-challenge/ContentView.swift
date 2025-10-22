//
//  ContentView.swift
//  day77-challenge
//
//  Created by Parmesh Yadav on 22/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var data = DataController()
    
    @State private var showingAdd = false
    @State private var selected: PersonPhoto?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(data.sortedItems) { item in
                    Button(action: { selected = item }) {
                        HStack {
                            if let imageData = data.imageData(for: item.imageFilename),
                               let uiImage = UIImage(data:imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .clipped()
                                    .clipShape(.capsule)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)
                                    .clipShape(.capsule)
                                    .overlay(Text("No\nImage").font(.caption).multilineTextAlignment(.center))
                            }
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .onDelete{ idx in
                    let toDelete = idx.map{ data.sortedItems[$0] }
                    for item in toDelete {
                        do {
                            try data.delete(item)
                        } catch {
                            print("Delete error: \(error.localizedDescription)")
                        }
                    }
                }
            }
            .navigationTitle("Name & Faces")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $selected) { item in
                DetailView(item: item)
                    .environmentObject(data)
            }
            .sheet(isPresented: $showingAdd) {
                AddView()
                    .environmentObject(data)
            }
        }
    }
}

#Preview {
    ContentView()
}

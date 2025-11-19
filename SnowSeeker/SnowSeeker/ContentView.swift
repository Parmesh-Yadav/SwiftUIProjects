//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Parmesh Yadav on 15/11/25.
//

import SwiftUI

struct ContentView: View {
    enum SortType: String, CaseIterable {
        case `default` = "Default"
        case alphabetical = "Alphabetical"
        case country = "Country"
    }
    
    @State private var searchText = ""
    @State private var favorites = Favorites()
    @State private var sortType: SortType = .default
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    var filteredResorts: [Resort] {
        var result = searchText.isEmpty ? resorts : resorts.filter{$0.name.localizedStandardContains(searchText)}
        
        switch sortType {
        case .default:
            break
        case .alphabetical:
            result.sort{$0.name < $1.name}
        case .country:
            result.sort{$0.country < $1.country}
        }
        
        return result
    }
    
    var body: some View {
        NavigationSplitView {
            List(filteredResorts) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(.rect(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resot")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                ToolbarItem {
                    Menu {
                        ForEach(SortType.allCases, id:\.self) { type in
                            Button {
                                sortType = type
                            } label: {
                                HStack {
                                    Text(type.rawValue)
                                    
                                    if sortType == type {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .foregroundStyle(sortType == type ? .blue : .primary)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
    
}

#Preview {
    ContentView()
}
 

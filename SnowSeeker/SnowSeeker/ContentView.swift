//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Parmesh Yadav on 15/11/25.
//

import SwiftUI

struct ContentView: View {
    enum SortType: String, CaseIterable {
        case `default` = "Relevance"
        case alphabetical = "Name"
        case country = "Country"
    }
    
    @State private var searchText = ""
    @State private var favorites = Favorites()
    @State private var sortType: SortType = .default
    @State private var showSortMenu = false
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    var filteredResorts: [Resort] {
        var result = searchText.isEmpty ? resorts : resorts.filter{$0.name.localizedStandardContains(searchText)}
        
        switch sortType {
        case .default: break
        case .alphabetical: result.sort{$0.name < $1.name}
        case .country: result.sort{$0.country < $1.country}
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 30) {
                        // Minimalist Header
                        HStack {
                            Text("SnowSeeker")
                                .font(.system(size: 34, weight: .bold, design: .serif))
                            Spacer()
                            
                            // Sort Button
                            Button {
                                withAnimation(.snappy) { showSortMenu.toggle() }
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.title2)
                                    .foregroundStyle(.primary)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Search Field (Clean)
                        HStack {
                            Image(systemName: "magnifyingglass").opacity(0.5)
                            TextField("Find your mountain...", text: $searchText)
                        }
                        .padding()
                        .background(Color.primary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                        // The List
                        LazyVStack(spacing: 20) {
                            ForEach(filteredResorts) { resort in
                                NavigationLink(value: resort) {
                                    ResortCardView(resort: resort, isFavorite: favorites.contains(resort))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 80)
                    }
                }
                .scrollIndicators(.hidden)
                
                // Custom Sort Menu Overlay
                if showSortMenu {
                    SortOverlay(selectedSort: $sortType, isPresented: $showSortMenu)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
        }
        .environment(favorites)
    }
}

// MARK: - Subviews

struct ResortCardView: View {
    let resort: Resort
    let isFavorite: Bool
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(resort.id)
                .resizable()
                .scaledToFill()
                .frame(height: 280)
                .overlay(
                    LinearGradient(colors: [.black.opacity(0.6), .clear], startPoint: .bottom, endPoint: .center)
                )
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(resort.country.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(2)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    if isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
                
                Text(resort.name)
                    .font(.system(size: 32, weight: .medium, design: .serif))
                    .foregroundStyle(.white)
                
                Text("\(resort.runs) Runs • \(resort.size == 1 ? "Small" : resort.size == 2 ? "Medium" : "Large") Area")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(25)
        }
        // iOS 17 Scroll Transition: Cards shrink and blur as they scroll away
        .scrollTransition { content, phase in
            content
                .opacity(phase.isIdentity ? 1 : 0.8)
                .scaleEffect(phase.isIdentity ? 1 : 0.9)
                .blur(radius: phase.isIdentity ? 0 : 2)
        }
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

struct SortOverlay: View {
    @Binding var selectedSort: ContentView.SortType
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                Text("Sort By")
                    .font(.headline)
                    .foregroundStyle(.gray)
                
                ForEach(ContentView.SortType.allCases, id: \.self) { type in
                    Button {
                        selectedSort = type
                        withAnimation { isPresented = false }
                    } label: {
                        HStack {
                            Text(type.rawValue)
                                .font(.title3)
                                .foregroundStyle(.primary)
                            Spacer()
                            if selectedSort == type {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    Divider()
                }
            }
            .padding(30)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding()
        }
        .background(Color.black.opacity(0.2).onTapGesture {
            withAnimation { isPresented = false }
        })
    }
}

#Preview {
    ContentView()
}

//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Parmesh Yadav on 17/11/25.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dismiss) var dismiss
    @Environment(Favorites.self) var favorites
    
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    @State private var isAppeared = false
    
    let resort: Resort
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(spacing: 0) {
                    // Parallax Hero Image
                    GeometryReader { proxy in
                        let minY = proxy.frame(in: .global).minY
                        Image(decorative: resort.id)
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: 400 + (minY > 0 ? minY : 0))
                            .offset(y: minY > 0 ? -minY : 0)
                            .overlay(
                                LinearGradient(colors: [.black.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom)
                            )
                    }
                    .frame(height: 400)
                    
                    // Content Sheet
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text(resort.country.uppercased())
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                                .tracking(2)
                            
                            HStack(alignment: .top) {
                                Text(resort.name)
                                    .font(.system(size: 40, weight: .light, design: .serif))
                                Spacer()
                                PriceView(price: resort.price)
                            }
                        }
                        
                        Divider()
                        
                        // Key Stats (Minimalist Row)
                        HStack(spacing: 0) {
                            StatItem(label: "Elevation", value: "\(resort.elevation)m")
                            StatItem(label: "Snow", value: "\(resort.snowDepth)cm")
                            StatItem(label: "Runs", value: "\(resort.runs)")
                        }
                        .padding(.vertical, 5)
                        
                        Divider()
                        
                        // Description
                        Text(resort.description)
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .lineSpacing(6)
                            .foregroundStyle(.secondary)
                        
                        // Facilities
                        Text("Facilities")
                            .font(.headline)
                            .padding(.top, 10)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(resort.facilityTypes) { facility in
                                    Button {
                                        selectedFacility = facility
                                        showingFacility = true
                                    } label: {
                                        HStack {
                                            facility.icon
                                                .font(.title2)
                                            Text(facility.name)
                                                .font(.subheadline)
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 14)
                                        .background(Color.primary.opacity(0.05))
                                        .clipShape(Capsule())
                                        .foregroundStyle(.primary)
                                    }
                                }
                            }
                        }
                        
                        // Action Button
                        Button {
                            withAnimation(.spring) {
                                if favorites.contains(resort) {
                                    favorites.remove(resort)
                                } else {
                                    favorites.add(resort)
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: favorites.contains(resort) ? "heart.slash" : "heart")
                                Text(favorites.contains(resort) ? "Remove from favorites" : "Mark as Favorite")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(favorites.contains(resort) ? Color.red.opacity(0.1) : Color.primary)
                            .foregroundStyle(favorites.contains(resort) ? Color.red : Color(uiColor: .systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(30)
                    .background(Color(uiColor: .systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                    .offset(y: -40) // Pulls the sheet up over the image
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // Floating Back Button
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(12)
                    .background(.thinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(.leading, 20)
            .padding(.top, 60)
        }
        .navigationBarBackButtonHidden(true)
        .alert(selectedFacility?.name ?? "Info", isPresented: $showingFacility, presenting: selectedFacility) { _ in
        } message: { facility in
            Text(facility.description)
        }
        .opacity(isAppeared ? 1 : 0)
        .onAppear { withAnimation { isAppeared = true } }
    }
}

// MARK: - Helper Components for ResortView

struct StatItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label.uppercased())
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.tertiary)
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
//                .designWithSerif() // Helper logic below
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // Tiny helper to keep main view clean
//    func designWithSerif() -> some View {
//        Text(value).font(.system(.title3, design: .serif))
//    }
}

struct PriceView: View {
    let price: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { i in
                Text("$")
                    .font(.title3)
                    .foregroundColor(i < price ? .primary : .secondary.opacity(0.3))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ResortView(resort: Resort.example)
            .environment(Favorites())
    }
}

//
//  DetailView.swift
//  day77-challenge
//
//  Created by Parmesh Yadav on 22/10/25.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @EnvironmentObject var data: DataController
    @Environment(\.dismiss) var dismiss
    
    @State private var region: MKCoordinateRegion?
    
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
                
                if let lat = item.latitude, let lon = item.longitude {
                    let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let regionValue = MKCoordinateRegion(
                        center: coord,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                    
                    if #available(iOS 17.0, *) {
                        Map(initialPosition: .region(regionValue)) {
                            Marker(item.name, coordinate: coord)
                        }
                        .frame(height: 300)
                        .clipShape(.rect)
                        .padding(.horizontal)
                    } else {
                        Map(coordinateRegion: Binding(
                            get: {
                                region ?? regionValue
                            },
                            set: { region = $0 }
                        ), annotationItems: [item]) { _ in
                            MapMarker(coordinate: coord, tint: .red)
                        }
                        .frame(height: 300)
                        .clipShape(.rect)
                        .padding(.horizontal)
                    }
                } else {
                    Text("Location data not availble.")
                        .foregroundStyle(.secondary)
                }
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

//
//  ContentView.swift
//  BucketList
//
//  Created by Parmesh Yadav on 10/10/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var viewModel = ViewModel()
    @State private var usingHybrid = false
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    var body: some View {
        NavigationStack{
            if viewModel.isUnlocked {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .onLongPressGesture {
                                        viewModel.selectedLocation = location
                                    }
                            }
                        }
                    }
                    .mapStyle(usingHybrid ? .hybrid : .standard)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedLocation) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
                .navigationTitle("Maps")
                .toolbar {
                    ToolbarItem {
                        Button("Switch map style") {
                            usingHybrid.toggle()
                        }
                    }
                }
            } else {
                Button("Unlock places", action: viewModel.authenticate)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
        .alert(
            "Authentication Error",
            isPresented: Binding(
                get: { viewModel.alertMessage != nil },
                set: { newValue in
                    if newValue == false {
                        viewModel.alertMessage = nil
                    }
                }
            ),
            actions: {
                Button("OK") {
                    viewModel.alertMessage = nil
                }
            },
            message: {
                Text(viewModel.alertMessage ?? "")
            }
        )
    }
    
}

#Preview {
    ContentView()
}

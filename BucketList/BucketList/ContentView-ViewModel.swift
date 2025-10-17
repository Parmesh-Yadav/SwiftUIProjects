//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Parmesh Yadav on 16/10/25.
//

import Foundation
import MapKit
import CoreLocation
import LocalAuthentication

extension ContentView{
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedLocation: Location?
        var isUnlocked = true
        var alertMessage: String? = nil
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlace")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
               print("Unable to save data")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedLocation else { return }
            if let index = locations.firstIndex(of: selectedLocation) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authencationError in
                    DispatchQueue.main.async {
                        if success {
                            self.isUnlocked = true
                        } else {
                            self.alertMessage = authencationError?.localizedDescription ?? "Authentication failed."
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "Biometric authentication not available."
                }
            }
        }
    }
}

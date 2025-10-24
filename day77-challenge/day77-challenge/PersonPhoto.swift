//
//  PersonPhoto.swift
//  day77-challenge
//
//  Created by Parmesh Yadav on 22/10/25.
//

import Foundation


struct PersonPhoto: Identifiable, Codable, Comparable {
    let id: UUID
    var name: String
    let imageFilename: String
    let createdAt: Date
    var latitude: Double?
    var longitude: Double?
    
    init(id: UUID = UUID(), name: String, imageFilename: String, createdAt: Date, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = id
        self.name = name
        self.imageFilename = imageFilename
        self.createdAt = createdAt
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func < (lhs: PersonPhoto, rhs: PersonPhoto) -> Bool {
        lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
    }
}

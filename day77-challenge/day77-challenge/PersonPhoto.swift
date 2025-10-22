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
    
    init(id: UUID = UUID(), name: String, imageFilename: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.imageFilename = imageFilename
        self.createdAt = createdAt
    }
    
    static func < (lhs: PersonPhoto, rhs: PersonPhoto) -> Bool {
        lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
    }
}

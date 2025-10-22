//
//  DataController.swift
//  day77-challenge
//
//  Created by Parmesh Yadav on 22/10/25.
//

import Foundation
internal import Combine

final class DataController: ObservableObject {
    @Published private(set) var items: [PersonPhoto] = []
    
    private let metaDataURL: URL
    private let fileManager = FileManager.default
    
    var sortedItems: [PersonPhoto] {
        items.sorted()
    }
    
    init(fileName: String = "people_metadata.json") {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        metaDataURL = docs.appendingPathComponent(fileName)
        load();
    }
    
    private func load() {
        do {
            let data = try Data(contentsOf: metaDataURL)
            let decoded = try JSONDecoder().decode([PersonPhoto].self, from: data)
            items = decoded
        } catch {
            items = []
        }
    }
    
    private func imageFileURL(for fileName: String) -> URL {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent(fileName)
    }
    
    func add(name: String, imageData: Data) throws {
        let uuid = UUID().uuidString
        let imageFileName = "\(uuid).jpg"
        let imageURL = imageFileURL(for: imageFileName)
        try imageData.write(to: imageURL, options: .atomic)
        let item = PersonPhoto(name: name, imageFilename: imageFileName, createdAt: Date.now)
        items.append(item)
        try save()
    }
    
    func delete(_ item: PersonPhoto) throws {
        let url = imageFileURL(for: item.imageFilename)
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
        items.removeAll{ $0.id == item.id}
        try save()
    }
    
    private func save() throws {
        let data = try JSONEncoder().encode(items)
        try data.write(to: metaDataURL, options: .atomic)
    }
    
    func imageData(for filename: String) -> Data? {
        let url = imageFileURL(for: filename)
        return try? Data(contentsOf: url)
    }
}

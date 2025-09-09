//
//  Bundle-Decodable.swift
//  MoonShot
//
//  Created by Parmesh Yadav on 08/09/25.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate the file in the bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load the file from the bundle")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode the file from the bundle due to a missing key: \(key), context: \(context)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode the file due to type mismatch, context: \(context)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode the file due to missing value, type: \(type), context: \(context)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode the file due to invalid JSON")
        } catch {
            fatalError("Failed to decode because of an unknown error: \(error)")
        }
    }
}

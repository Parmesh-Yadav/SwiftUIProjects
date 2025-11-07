//
//  Card.swift
//  Flashzilla
//
//  Created by Parmesh Yadav on 05/11/25.
//

import Foundation

struct Card: Codable{
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "Who played the 13th doctor in Doctor Who?", answer: "Jodie Whittaker")
}

//
//  ContentView.swift
//  HotProspects
//
//  Created by Parmesh Yadav on 26/10/25.
//

import SamplePackage
import SwiftUI

struct ContentView: View {
    let possibleNumbers = Array(1...60)
    
    var results: String {
        let selected = possibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.formatted()
    }
    
    var body: some View {
        Text(results)
    }

}

#Preview {
    ContentView()
}

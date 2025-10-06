//
//  ContentView.swift
//  Instafilter
//
//  Created by Parmesh Yadav on 03/10/25.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        Button("Leave a review") {
            requestReview()
        }
    }

}

#Preview {
    ContentView()
}

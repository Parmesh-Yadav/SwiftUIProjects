//
//  RatingView.swift
//  Bookworm
//
//  Created by Parmesh Yadav on 24/09/25.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    var label = ""
    var maxRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if !label.isEmpty {
               Text(label)
            }
            
            ForEach(1..<maxRating + 1, id:\.self) { number in
                Button {
                    withAnimation {
                        rating = number
                    }
                } label: {
                    image(for: number)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        }
        return onImage
    }
}

#Preview {
    RatingView(rating: .constant(3))
}

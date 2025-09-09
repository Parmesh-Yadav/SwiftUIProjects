//
//  RectangleDividersView.swift
//  MoonShot
//
//  Created by Parmesh Yadav on 09/09/25.
//

import SwiftUI

struct RectangleDividersView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

#Preview {
    RectangleDividersView()
}

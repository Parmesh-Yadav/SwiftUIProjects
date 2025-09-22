//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Parmesh Yadav on 18/09/25.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                
                TextField("Street Address", text: $order.streetAddress)
                
                TextField("City", text: $order.city)
                
                TextField("Zip", text: $order.zip)
            }
            
            Section{
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(!order.hasValidAddress)
        }
        .navigationTitle("Delivery Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}

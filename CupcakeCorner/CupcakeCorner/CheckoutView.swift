//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Parmesh Yadav on 20/09/25.
//

import SwiftUI

struct CheckoutView: View {
    struct OrderError: Identifiable {
        let id = UUID()
        let message: String
    }
    
    var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var orderError: OrderError? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        //error alert
        .alert(item: $orderError) { error in
            Alert(
                title: Text("Order Failed"),
                message: Text(error.message),
                primaryButton: .default(Text("Retry")) {
                    Task {
                        await placeOrder()
                    }
                },
                secondaryButton: .cancel()
            )
        }
        //success alert
        .alert("Thank You", isPresented: $showingConfirmation) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
    }
    
    @MainActor
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                            orderError = OrderError(
                                message: "Server returned status code \(httpResponse.statusCode). Please try again."
                            )
                            return
                        }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                    print("Server response: \(jsonString)")
            }
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes in on its way!"
            showingConfirmation = true
        } catch {
            orderError = OrderError(message: "Check out failed — \(error.localizedDescription).\nPlease check your internet connection and try again.")
            print("Check out failed error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}

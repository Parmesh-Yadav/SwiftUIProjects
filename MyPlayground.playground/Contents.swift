import Cocoa

func a(_ array: [Int]?) -> Int {
    return (array?.isEmpty == false ? array![Int.random(in: 0..<array!.count)] : nil) ?? Int.random(in: 1...100)
}

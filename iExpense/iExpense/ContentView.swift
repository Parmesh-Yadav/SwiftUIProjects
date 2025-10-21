//
//  ContentView.swift
//  iExpense
//
//  Created by Parmesh Yadav on 28/08/25.
//

import SwiftUI
import SwiftData

enum SortType: String, CaseIterable, Identifiable {
    case name = "Name"
    case amount = "Amount"
    var id: String{ rawValue }
}

enum FilterType: String, CaseIterable, Identifiable {
    case all = "All"
    case personal = "Personal"
    case business = "Business"
    var id: String{ rawValue }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [ExpenseItem]
    @State private var path = NavigationPath()
    @State private var sortType: SortType
    @State private var filterType: FilterType
    
    init(sortType: SortType = .name, filterType: FilterType = .all) {
        _sortType = State(initialValue: sortType)
        _filterType = State(initialValue: filterType)
        
        let predicate: Predicate<ExpenseItem>?
        switch filterType {
        case .all:
            predicate = nil
        case .personal:
            predicate = #Predicate {$0.type == "Personal"}
        case .business:
            predicate = #Predicate {$0.type == "Business"}
        }
        
        let sort: [SortDescriptor<ExpenseItem>]
        switch sortType {
        case .amount:
            sort = [SortDescriptor(\.amount, order: .forward)]
        case .name:
            sort = [SortDescriptor(\.name, order: .forward)]
        }
        
        _items = Query(filter: predicate, sort: sort)
    }
    
    var body: some View {
        NavigationStack(path: $path){
            List {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                                .foregroundStyle(item.amount > 5000 ? .red : .primary)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: item.currency))
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(item.name), \(item.amount.formatted(.currency(code: item.currency)))")
                    .accessibilityHint("Expense type: \(item.type)")
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem {
                    Button{
                        path.append("Add View")
                    } label : {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem {
                    Menu {
                        Picker("Sort by", selection: $sortType) {
                            ForEach(SortType.allCases){ sort in
                                Text(sort.rawValue)
                                    .tag(sort)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem {
                    Menu {
                        Picker("Filter", selection: $filterType) {
                            ForEach(FilterType.allCases) { filter in
                                Text(filter.rawValue)
                                    .tag(filter)
                            }
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "Add View" {
                    AddView()
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ContentView()
}

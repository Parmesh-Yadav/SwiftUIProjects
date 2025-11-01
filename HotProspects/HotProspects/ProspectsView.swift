//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Parmesh Yadav on 29/10/25.
//

import SwiftUI
import SwiftData
import CodeScanner
import AVFoundation
import UserNotifications

struct ProspectsView: View {
    enum SortType {
        case name, date
    }
    
    @Environment(\.modelContext) var modelContext
    @Query var prospects: [Prospect]
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<UUID>()
    @State private var sortType: SortType = .name
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted People"
        case .uncontacted:
            "Uncontacted People"
        }
    }
    
    // Avoid capturing local variables inside the predicate builder.
    var filterPredicate: Predicate<Prospect>? {
        switch filter {
        case .none:
            return nil
        case .contacted:
            return #Predicate { $0.isContacted == true }
        case .uncontacted:
            return #Predicate { $0.isContacted == false }
        }
    }

    
    var body: some View {
        NavigationStack {
            List(prospects, selection: $selectedProspects) { prospect in
                NavigationLink {
                    EditProspectsView(prospect: prospect)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            
                            Text(prospect.email)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        if filter == .none {
                            Image(systemName: prospect.isContacted ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(prospect.isContacted ? .green : .red)
                        }
                    }
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind Me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect.id)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Button("Sort by Name") {
                            sortType = .name
                            _prospects = Query(
                                filter: filterPredicate,
                                sort: [SortDescriptor(\Prospect.name)]
                            )
                        }
                                    
                        Button("Sort by Most Recent") {
                            sortType = .date
                            _prospects = Query(
                                filter: filterPredicate,
                                sort: [SortDescriptor(\Prospect.dateAdded, order: .reverse)]
                            )
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .overlay(alignment: .bottom) {
                if selectedProspects.isEmpty == false {
                    Button {
                        delete()
                    } label: {
                        Label("Delete Selected", systemImage: "trash")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                            .padding()
                            .shadow(radius: 4)
                    }
                    // Lift above TabView
                    .padding(.bottom, 10)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: selectedProspects)
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Parmesh Yadav\nparmesh.bk@gmail.com", completion: handleScan)
            }
        }
    }
    
    init(filter: FilterType) {
        self.filter = filter
        
        let predicate: Predicate<Prospect>?
        switch filter {
        case .none:
            predicate = nil
        case .contacted:
            predicate = #Predicate { $0.isContacted == true }
        case .uncontacted:
            predicate = #Predicate { $0.isContacted == false }
        }
        
        _prospects = Query(
            filter: predicate,
            sort: [SortDescriptor(\Prospect.name)]
        )
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect(name: details[0], email: details[1], isContacted: false)
            modelContext.insert(person)
            
        case .failure(let failure):
            print("Scanning Failed: \(failure.localizedDescription)")
        }
    }
    
    func delete() {
        let toDelete = prospects.filter { selectedProspects.contains($0.id) }
        for prospect in toDelete {
            modelContext.delete(prospect)
        }
        selectedProspects.removeAll()
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.email
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { setting in
            if setting.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    ProspectsView(filter: .contacted)
        .modelContainer(for: Prospect.self)
}

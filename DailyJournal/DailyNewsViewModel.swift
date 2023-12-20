//
//  DailyNewsViewModel.swift
//  DailyJournal
//
//  Created by Anna Sumire on 21.12.23.
//

import Foundation

final class DailyNewsViewModel: ObservableObject {
    @Published var title = ""
    @Published var newsText = ""
    @Published var creationDate = Date()
    @Published var showRequirementsAlert = false
    @Published var entries: [[String: String]] {
        didSet {
            UserDefaults.standard.set(entries, forKey: "SavedEntries")
        }
    }
    
    init() {
        if let savedEntries = UserDefaults.standard.array(forKey: "SavedEntries") as? [[String: String]] {
            self.entries = savedEntries
        } else {
            self.entries = []
        }
    }
    
    func saveButtonPressed() {
        if title.count > 5 && newsText.count > 5 {
            entries.append(["title": title, "text": newsText])
            title = ""
            newsText = ""
        } else {
            showRequirementsAlert = true
        }
    }
    
    func editPressed(fromOffsets: IndexSet, toOffset: Int) {
        entries.move(fromOffsets: fromOffsets, toOffset: toOffset)
    }
    
    func deletePressed(at index: IndexSet) {
        entries.remove(atOffsets: index)
    }
}


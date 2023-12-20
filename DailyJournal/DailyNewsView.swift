//
//  DailyNewsView.swift
//  DailyJournal
//
//  Created by Anna Sumire on 20.12.23.
//

import SwiftUI

struct DailyNewsView: View {
        
    @StateObject private var viewModel = DailyNewsViewModel()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                formView
                listView
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .navigationTitle("Daily Journal")
            .alert("Enty can't be saved", isPresented: $viewModel.showRequirementsAlert) {
                // ok button
            } message: {
                Text("Your title and text must contain at least 5 characters!")
            }
        }
    }
    
    
    private var formView: some View {
        Form {
            Section(header: Text("Journal Entry")) {
                TextField("News Title", text: $viewModel.title)
                
                TextField("News Text", text: $viewModel.newsText, axis: .vertical)
                    .lineLimit(5)
                    .frame(height: 150)
                
                DatePicker("Select Date", selection: $viewModel.creationDate, displayedComponents: .date)
            }
        }
    }
    
    private var listView: some View {
        Group {
            if viewModel.entries.isEmpty {
                emptyListView
            } else {
                List {
                    ForEach($viewModel.entries.indices, id: \.self) { index in
                        HStack {
                            Text(viewModel.entries[index]["title"] ?? "")
                            Text(viewModel.entries[index]["text"] ?? "")
                            
                            Spacer()
                            Text(dateFormatter.string(from: viewModel.creationDate))
                        }
                    }
                    .onMove(perform: viewModel.editPressed)
                    .onDelete(perform: viewModel.deletePressed)
                }
            }
        }
    }

    private var saveButton: some View {
        Button(action: {
            viewModel.saveButtonPressed()
        }) {
            Text("Save")
        }
    }
    
    private var emptyListView: some View {
        Image("empty")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 300, height: 300)
    }
}


#Preview {
    DailyNewsView()
}

//
//  ProgramListView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct ProgramListView: View {
    @Binding var programs: [Program]
    @State private var selectedPrograms: Set<UUID> = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(programs) { program in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(program.name).bold()
                            Spacer()
                            Text(program.applicationDeadline, style: .date).font(.caption)
                        }
                        
                        Text("Theme: \(program.theme.rawValue), \(program.country)/\(program.city)")
                            .font(.footnote)
                        
                        HStack {
                            Button(action: { toggleSelection(program.id) }) {
                                Image(systemName: selectedPrograms.contains(program.id) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.burntOrange)
                            }
                            Spacer()
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            programs.removeAll { $0.id == program.id }
                            Storage.savePrograms(programs)
                        } label: { Label("Delete", systemImage: "trash") }
                        
                        Button {
                            // edit logic
                            if let idx = programs.firstIndex(of: program) {
                                // set editProgramID in AddProgramView
                                // handled via parent ContentView binding
                            }
                        } label: { Label("Edit", systemImage: "pencil") }
                        .tint(.burntOrange)
                    }
                }
            }
            .navigationTitle("All Programs")
        }
    }
    
    func toggleSelection(_ id: UUID) {
        if selectedPrograms.contains(id) { selectedPrograms.remove(id) }
        else { selectedPrograms.insert(id) }
    }
}

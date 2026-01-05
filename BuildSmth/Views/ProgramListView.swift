//
//  ProgramListView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct ProgramListView: View {
    @Binding var programs: [Program]
    @Binding var editingProgram: Program?
    @Binding var selectedTab: Int
    
    @State private var selectedPrograms: Set<UUID> = []
    @State private var expandedProgram: UUID? = nil
    @State private var showCopyAlert = false
    @State private var isSelectionMode = false
    @State private var hidePastPrograms = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Top Row: Hide Past Toggle + Select Button
                HStack {
                    Toggle("Hide Past Programs", isOn: $hidePastPrograms)
                        .toggleStyle(SwitchToggleStyle(tint: .vibrantBlue))
                    
                    Spacer(minLength: 30)
                    
                    if !programs.isEmpty {
                        Button(action: { isSelectionMode.toggle() }) {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                Text("Select")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.vibrantBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color.softGray.opacity(0.5))
                
                if programs.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "tray")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        Text("No programs yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Add your first program to get started!")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    // MARK: - Sorted & Filtered Programs
                    let filteredPrograms = programs
                        .filter { !hidePastPrograms || $0.applicationDeadline >= Date() }
                        .sorted { $0.applicationDeadline < $1.applicationDeadline }
                    
                    List {
                        ForEach(filteredPrograms) { program in
                            VStack(spacing: 0) {
                                // Collapsed row
                                Button(action: {
                                    if isSelectionMode {
                                        toggleSelection(program.id)
                                    } else {
                                        withAnimation {
                                            expandedProgram = expandedProgram == program.id ? nil : program.id
                                        }
                                    }
                                }) {
                                    HStack(spacing: 12) {
                                        if isSelectionMode {
                                            Image(systemName: selectedPrograms.contains(program.id) ? "checkmark.circle.fill" : "circle")
                                                .font(.title3)
                                                .foregroundColor(selectedPrograms.contains(program.id) ? .vibrantBlue : .gray)
                                        }
                                        
                                        // Theme color indicator
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(program.theme.color)
                                            .frame(width: 4, height: 50)
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(program.name)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                                .lineLimit(expandedProgram == program.id ? nil : 2)
                                            
                                            HStack {
                                                Image(systemName: "calendar")
                                                    .font(.caption)
                                                Text(program.applicationDeadline, style: .date)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            HStack {
                                                Image(systemName: program.isVirtual ? "network" : "location.fill")
                                                    .font(.caption)
                                                Text(program.isVirtual ? "Virtual" : "\(program.city), \(program.country)")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        if !isSelectionMode {
                                            // Star button
                                            Button(action: { toggleStar(for: program) }) {
                                                Image(systemName: program.isStarred ? "star.fill" : "star")
                                                    .foregroundColor(program.isStarred ? .yellow : .gray)
                                                    .font(.title3)
                                            }
                                            .buttonStyle(.plain)
                                            
                                            Image(systemName: expandedProgram == program.id ? "chevron.up" : "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.vertical, 12)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                
                                // Expanded row
                                if expandedProgram == program.id {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Divider()
                                        
                                        // Theme
                                        HStack {
                                            Circle()
                                                .fill(program.theme.color)
                                                .frame(width: 12, height: 12)
                                            Text("Theme:")
                                                .fontWeight(.medium)
                                            Text(program.theme.rawValue)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        // Dates
                                        VStack(alignment: .leading, spacing: 6) {
                                            if let start = program.startDate {
                                                HStack {
                                                    Image(systemName: "calendar.badge.clock")
                                                        .foregroundColor(.vibrantBlue)
                                                    Text("Start:")
                                                        .fontWeight(.medium)
                                                    Text(start, style: .date)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            
                                            if let end = program.endDate {
                                                HStack {
                                                    Image(systemName: "calendar.badge.checkmark")
                                                        .foregroundColor(.vibrantPurple)
                                                    Text("End:")
                                                        .fontWeight(.medium)
                                                    Text(end, style: .date)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                        }
                                        
                                        // Requirements
                                        if !program.requirements.isEmpty {
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text("Requirements:")
                                                    .fontWeight(.medium)
                                                ForEach(program.requirements, id: \.self) { req in
                                                    HStack(alignment: .top) {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(.vibrantGreen)
                                                            .font(.caption)
                                                        Text(req)
                                                            .font(.body)
                                                            .foregroundColor(.secondary)
                                                    }
                                                }
                                            }
                                        }
                                        
                                        // Website
                                        if !program.website.isEmpty, let url = URL(string: program.website) {
                                            Link(destination: url) {
                                                HStack {
                                                    Image(systemName: "link")
                                                    Text("Visit Website")
                                                    Spacer()
                                                    Image(systemName: "arrow.up.right")
                                                }
                                                .foregroundColor(.vibrantBlue)
                                                .padding(10)
                                                .background(Color.vibrantBlue.opacity(0.1))
                                                .cornerRadius(8)
                                            }
                                        }
                                        
                                        // Action buttons
                                        HStack(spacing: 12) {
                                            Button(action: {
                                                editingProgram = program
                                                selectedTab = 0
                                            }) {
                                                HStack {
                                                    Image(systemName: "pencil")
                                                    Text("Edit")
                                                }
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                                .background(Color.vibrantOrange)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                            }
                                            
                                            Button(action: {
                                                deleteProgram(program)
                                            }) {
                                                HStack {
                                                    Image(systemName: "trash")
                                                    Text("Delete")
                                                }
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                                .background(Color.red)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                            }
                                        }
                                    }
                                    .padding(.top, 8)
                                    .padding(.bottom, 12)
                                    .transition(.opacity)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("All Programs")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Copied!", isPresented: $showCopyAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(selectedPrograms.count) program(s) copied to clipboard")
        }
    }
    
    // MARK: - Functions
    
    func toggleSelection(_ id: UUID) {
        if selectedPrograms.contains(id) {
            selectedPrograms.remove(id)
        } else {
            selectedPrograms.insert(id)
        }
    }
    
    func toggleStar(for program: Program) {
        guard let index = programs.firstIndex(where: { $0.id == program.id }) else { return }
        programs[index].isStarred.toggle()
        Storage.savePrograms(programs)
    }
    
    func deleteProgram(_ program: Program) {
        programs.removeAll { $0.id == program.id }
        selectedPrograms.remove(program.id)
        Storage.savePrograms(programs)
    }
    
    func copySelectedPrograms() {
        let selectedProgramsList = programs.filter { selectedPrograms.contains($0.id) }
        let text = selectedProgramsList.map { $0.formattedText() }.joined(separator: "\n")
        UIPasteboard.general.string = text
        showCopyAlert = true
        isSelectionMode = false
        selectedPrograms.removeAll()
    }
}

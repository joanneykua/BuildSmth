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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if !programs.isEmpty {
                    // Action bar
                    HStack {
                        if isSelectionMode {
                            Button(action: {
                                if selectedPrograms.count == programs.count {
                                    selectedPrograms.removeAll()
                                } else {
                                    selectedPrograms = Set(programs.map { $0.id })
                                }
                            }) {
                                HStack {
                                    Image(systemName: selectedPrograms.count == programs.count ? "checkmark.square.fill" : "square")
                                    Text("Select All")
                                }
                                .foregroundColor(.vibrantBlue)
                            }
                            
                            Spacer()
                            
                            Button(action: copySelectedPrograms) {
                                HStack {
                                    Image(systemName: "doc.on.doc.fill")
                                    Text("Copy (\(selectedPrograms.count))")
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedPrograms.isEmpty ? Color.gray : Color.vibrantGreen)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .disabled(selectedPrograms.isEmpty)
                            
                            Button(action: {
                                isSelectionMode = false
                                selectedPrograms.removeAll()
                            }) {
                                Text("Cancel")
                                    .foregroundColor(.red)
                            }
                        } else {
                            Spacer()
                            Button(action: { isSelectionMode = true }) {
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
                }
                
                if programs.isEmpty {
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
                    List {
                        ForEach(programs) { program in
                            ProgramRow(
                                program: program,
                                isExpanded: expandedProgram == program.id,
                                isSelected: selectedPrograms.contains(program.id),
                                isSelectionMode: isSelectionMode,
                                onTap: {
                                    if isSelectionMode {
                                        toggleSelection(program.id)
                                    } else {
                                        withAnimation {
                                            expandedProgram = expandedProgram == program.id ? nil : program.id
                                        }
                                    }
                                },
                                onEdit: {
                                    editingProgram = program
                                    selectedTab = 0
                                },
                                onDelete: {
                                    deleteProgram(program)
                                }
                            )
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
    
    func toggleSelection(_ id: UUID) {
        if selectedPrograms.contains(id) {
            selectedPrograms.remove(id)
        } else {
            selectedPrograms.insert(id)
        }
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

struct ProgramRow: View {
    let program: Program
    let isExpanded: Bool
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            Button(action: onTap) {
                HStack(spacing: 12) {
                    if isSelectionMode {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundColor(isSelected ? .vibrantBlue : .gray)
                    }
                    
                    // Theme color indicator
                    RoundedRectangle(cornerRadius: 4)
                        .fill(program.theme.color)
                        .frame(width: 4, height: 50)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(program.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(isExpanded ? nil : 2)
                        
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
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if isExpanded {
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
                    if !program.website.isEmpty {
                        if let url = URL(string: program.website) {
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
                    }
                    
                    // Action buttons
                    HStack(spacing: 12) {
                        Button(action: onEdit) {
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
                        
                        Button(action: onDelete) {
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

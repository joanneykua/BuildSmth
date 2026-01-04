//
//  TagOverviewView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct TagOverviewView: View {
    let programs: [Program]
    @State private var selectedProgram: Program?
    
    var grouped: [String: [Program]] {
        Dictionary(grouping: programs.flatMap { program in
            program.tags.map { ($0, program) }
        }, by: { $0.0 })
        .mapValues { $0.map { $0.1 }.sorted { $0.applicationDeadline < $1.applicationDeadline } }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(grouped.keys.sorted(), id: \.self) { tag in
                    DisclosureGroup(tag) {
                        VStack(spacing: 8) {
                            ForEach(grouped[tag] ?? []) { program in
                                Button {
                                    selectedProgram = program
                                } label: {
                                    HStack {
                                        Text(program.name)
                                        Spacer()
                                        Text(program.applicationDeadline, style: .date)
                                            .foregroundColor(.red)
                                            .font(.caption)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        .padding(.leading)
                    }
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(14)
                }
            }
            .padding()
        }
        .overlay {
            if let program = selectedProgram {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { selectedProgram = nil }
                
                VStack {
                    card {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(program.name).font(.title2).bold()
                                    Spacer()
                                    Button {
                                        selectedProgram = nil
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                Divider()
                                
                                Text("Location: \(program.location)")
                                Text("Period: \(program.programPeriod)")
                                
                                Text("Requirements:")
                                ForEach(program.requirements, id: \.self) {
                                    Text("• \($0)")
                                }
                                
                                if !program.tags.isEmpty {
                                    Text("Tags: \(program.tags.joined(separator: ", "))")
                                }
                                
                                Text("Website: \(program.website)")
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                            .padding(.vertical)
                        }
                        .frame(maxHeight: 400)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("By Tag")
    }
}


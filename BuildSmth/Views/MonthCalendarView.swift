//
//  MonthCalendarView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct MonthCalendarView: View {
    let programs: [Program]
    @State private var selectedProgram: Program?
    
    // Group programs by month-year string
    var programsByMonth: [String: [Program]] {
        Dictionary(grouping: programs) { prog in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            return formatter.string(from: prog.applicationDeadline)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(programsByMonth.keys.sorted(), id: \.self) { month in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(month).font(.title3).bold()
                        
                        // Calendar grid (7 columns)
                        let programsInMonth = programsByMonth[month] ?? []
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                            ForEach(programsInMonth) { program in
                                let day = Calendar.current.component(.day, from: program.applicationDeadline)
                                
                                Button {
                                    selectedProgram = program
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 30, height: 30)
                                        Text("\(day)")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
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
        .navigationTitle("By Month")
    }
}


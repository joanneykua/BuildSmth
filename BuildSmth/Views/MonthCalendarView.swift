//
//  MonthCalendarView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct MonthCalendarView: View {
    @Binding var programs: [Program]
    @State private var selectedProgram: Program? = nil
    @State private var showPopup = false
    
    let calendar = Calendar.current
    let months = Calendar.current.monthSymbols
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AppHeader(title: "Overview by Month")
                
                ForEach(1...12, id: \.self) { monthIndex in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(months[monthIndex - 1])
                            .font(.headline)
                            .padding(.leading, 8)
                        
                        let daysInMonth = daysForMonth(monthIndex)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                            ForEach(daysInMonth, id: \.self) { day in
                                let programsOnDay = programs.filter {
                                    let comp = calendar.dateComponents([.year, .month, .day], from: $0.applicationDeadline)
                                    return comp.month == monthIndex && comp.day == day
                                }
                                
                                Text("\(day)")
                                    .frame(width: 30, height: 30)
                                    .background(programsOnDay.isEmpty ? Color.clear : Color.red.opacity(0.7))
                                    .cornerRadius(15)
                                    .foregroundColor(programsOnDay.isEmpty ? .black : .white)
                                    .onTapGesture {
                                        if let firstProgram = programsOnDay.first {
                                            selectedProgram = firstProgram
                                            showPopup = true
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .overlay {
            if showPopup, let program = selectedProgram {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showPopup = false
                        selectedProgram = nil
                    }
                
                popupCard(program: program)
                    .transition(.scale)
            }
        }
    }
    
    // Calculate all days for a given month (assuming current year)
    func daysForMonth(_ month: Int) -> [Int] {
        let year = calendar.component(.year, from: Date())
        let dateComponents = DateComponents(year: year, month: month)
        guard let date = calendar.date(from: dateComponents),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        return Array(range)
    }
    
    // Popup card
    @ViewBuilder
    func popupCard(program: Program) -> some View {
        VStack(spacing: 12) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text(program.name)
                        .font(.title2)
                        .bold()
                    
                    Text("Theme: \(program.theme.rawValue)")
                    Text("Virtual: \(program.isVirtual ? "Yes" : "No")")
                    Text("Country: \(program.country), City: \(program.city)")
                    
                    Text("Application Deadline: \(program.applicationDeadline, style: .date)")
                    if let start = program.startDate {
                        Text("Start Date: \(start, style: .date)")
                    } else {
                        Text("Start Date: Not specified")
                    }
                    
                    if let end = program.endDate {
                        Text("End Date: \(end, style: .date)")
                    } else {
                        Text("End Date: Not specified")
                    }
                    
                    if !program.requirements.isEmpty {
                        Text("Requirements:")
                            .bold()
                        ForEach(program.requirements, id: \.self) { req in
                            Text("• \(req)")
                        }
                    }
                    
                    if !program.website.isEmpty {
                        Link("Website", destination: URL(string: program.website)!)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
            
            Button("Close") {
                showPopup = false
                selectedProgram = nil
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.burntOrange)
            .foregroundColor(.white)
            .cornerRadius(14)
            .padding([.leading, .trailing, .bottom])
        }
        .frame(maxWidth: 350, maxHeight: 500)
        .background(Color.softGray)
        .cornerRadius(18)
        .shadow(radius: 8)
    }
}

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
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    let calendar = Calendar.current
    let months = Calendar.current.monthSymbols
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AppHeader(title: "Calendar Overview")
                
                // Year selector
                HStack {
                    Button(action: { selectedYear -= 1 }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.vibrantBlue)
                    }
                    
                    Text(String(describing: selectedYear))
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(minWidth: 100)
                    
                    Button(action: { selectedYear += 1 }) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundColor(.vibrantBlue)
                    }
                }
                .padding()
                .background(Color.softGray)
                .cornerRadius(15)
                
                // Months
                ForEach(1...12, id: \.self) { monthIndex in
                    VStack(alignment: .leading, spacing: 12) {
                        // Month header
                        HStack {
                            Circle()
                                .fill(monthColor(monthIndex))
                                .frame(width: 8, height: 8)
                            Text(months[monthIndex - 1])
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.darkBrown)
                        }
                        .padding(.horizontal)
                        
                        // Weekday headers
                        HStack {
                            ForEach(["Sun","Mon","Tue","Wed","Thu","Fri","Sat"], id: \.self) { day in
                                Text(day)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        // Calendar grid
                        let monthCells = calendarCells(month: monthIndex, year: selectedYear)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                            ForEach(monthCells.indices, id: \.self) { i in
                                if let day = monthCells[i] {
                                    let programsOnDay = programsForDate(day: day, month: monthIndex, year: selectedYear)
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(programsOnDay.isEmpty ? Color.clear : Color.red.opacity(0.8))
                                            .shadow(color: programsOnDay.isEmpty ? .clear : .red.opacity(0.3), radius: 3)
                                        
                                        VStack(spacing: 2) {
                                            Text("\(day)")
                                                .font(.system(size: 14, weight: programsOnDay.isEmpty ? .regular : .bold))
                                                .foregroundColor(programsOnDay.isEmpty ? .primary : .white)
                                            
                                            if !programsOnDay.isEmpty {
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 4, height: 4)
                                            }
                                        }
                                    }
                                    .frame(height: 40)
                                    .onTapGesture {
                                        if let firstProgram = programsOnDay.first {
                                            selectedProgram = firstProgram
                                            showPopup = true
                                        }
                                    }
                                } else {
                                    Text("").frame(height: 40)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.08), radius: 5, y: 3)
                    }
                }
            }
            .padding()
        }
        .overlay {
            if showPopup, let program = selectedProgram {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showPopup = false
                            selectedProgram = nil
                        }
                    }
                
                popupCard(program: program)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    // MARK: - Helpers
    
    func monthColor(_ month: Int) -> Color {
        let colors: [Color] = [
            .vibrantBlue, .vibrantPurple, .vibrantPink, .vibrantGreen,
            .vibrantOrange, .burntOrange, .sand, .vibrantBlue,
            .vibrantPurple, .vibrantGreen, .vibrantOrange, .vibrantPink
        ]
        return colors[(month - 1) % colors.count]
    }
    
    func programsForDate(day: Int, month: Int, year: Int) -> [Program] {
        programs.filter {
            let comp = calendar.dateComponents([.year, .month, .day], from: $0.applicationDeadline)
            return comp.year == year && comp.month == month && comp.day == day
        }
    }
    
    // Generates month cells with padding at start and end
    func calendarCells(month: Int, year: Int) -> [Int?] {
        let dateComponents = DateComponents(year: year, month: month)
        guard let date = calendar.date(from: dateComponents),
              let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
        
        let firstWeekdayOfMonth = calendar.component(.weekday, from: date)
        let emptyStart = firstWeekdayOfMonth - 1
        
        var cells: [Int?] = Array(repeating: nil, count: emptyStart)
        cells.append(contentsOf: range.map { $0 })
        
        while cells.count % 7 != 0 {
            cells.append(nil)
        }
        
        return cells
    }
    
    @ViewBuilder
    func popupCard(program: Program) -> some View {
        VStack(spacing: 16) {
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(program.theme.color)
                    .frame(width: 6, height: 60)
                
                VStack(alignment: .leading) {
                    Text(program.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(program.theme.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: program.isVirtual ? "network" : "location.fill")
                            .foregroundColor(.vibrantBlue)
                        Text(program.isVirtual ? "Virtual/Online" : "\(program.city), \(program.country)")
                    }
                    
                    HStack {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .foregroundColor(.red)
                        Text("Deadline: \(program.applicationDeadline, style: .date)")
                            .fontWeight(.medium)
                    }
                    
                    if let start = program.startDate {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundColor(.vibrantGreen)
                            Text("Start: \(start, style: .date)")
                        }
                    }
                    
                    if let end = program.endDate {
                        HStack {
                            Image(systemName: "calendar.badge.checkmark")
                                .foregroundColor(.vibrantPurple)
                            Text("End: \(end, style: .date)")
                        }
                    }
                    
                    if !program.requirements.isEmpty {
                        Divider()
                        Text("Requirements:")
                            .fontWeight(.bold)
                        ForEach(program.requirements, id: \.self) { req in
                            HStack(alignment: .top) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.vibrantGreen)
                                Text(req)
                                    .font(.body)
                            }
                        }
                    }
                    
                    if !program.website.isEmpty {
                        Divider()
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
                                .background(Color.vibrantBlue.opacity(0.15))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Button(action: {
                withAnimation {
                    showPopup = false
                    selectedProgram = nil
                }
            }) {
                Text("Close")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.burntOrange, Color.sand]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .frame(maxWidth: 380, maxHeight: 550)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
        .padding()
    }
}

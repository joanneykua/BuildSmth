//
//  OverviewHomeView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct OverviewHomeView: View {
    @Binding var programs: [Program]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    AppHeader(title: "Overview")
                    
                    // Statistics cards
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Total Programs",
                                value: "\(programs.count)",
                                icon: "list.bullet.rectangle",
                                color: .vibrantBlue
                            )
                            
                            StatCard(
                                title: "Upcoming",
                                value: "\(upcomingProgramsCount)",
                                icon: "calendar.badge.clock",
                                color: .vibrantGreen
                            )
                        }
                        
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Countries",
                                value: "\(uniqueCountries)",
                                icon: "globe",
                                color: .vibrantPurple
                            )
                            
                            StatCard(
                                title: "Virtual",
                                value: "\(virtualProgramsCount)",
                                icon: "network",
                                color: .vibrantOrange
                            )
                        }
                    }
                    
                    // Navigation cards
                    VStack(spacing: 16) {
                        NavigationLink {
                            OverviewCountryView(programs: $programs)
                        } label: {
                            NavigationCard(
                                title: "Browse by Country",
                                subtitle: "Explore programs in \(uniqueCountries) countries",
                                icon: "globe.asia.australia.fill",
                                gradient: [Color.vibrantBlue, Color.vibrantPurple]
                            )
                        }
                        
                        NavigationLink {
                            MonthCalendarView(programs: $programs)
                        } label: {
                            NavigationCard(
                                title: "Calendar View",
                                subtitle: "See deadlines on a monthly calendar",
                                icon: "calendar",
                                gradient: [Color.vibrantGreen, Color.vibrantBlue]
                            )
                        }
                        
                        NavigationLink {
                            ThemeOverviewView(programs: $programs)
                        } label: {
                            NavigationCard(
                                title: "Browse by Theme",
                                subtitle: "Filter programs by academic field",
                                icon: "tag.fill",
                                gradient: [Color.vibrantPink, Color.vibrantOrange]
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
    
    var upcomingProgramsCount: Int {
        programs.filter { $0.applicationDeadline >= Date() }.count
    }
    
    var uniqueCountries: Int {
        Set(programs.map { $0.country }).count
    }
    
    var virtualProgramsCount: Int {
        programs.filter { $0.isVirtual }.count
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.darkBrown)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, color.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .shadow(color: color.opacity(0.2), radius: 8, y: 4)
    }
}

struct NavigationCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: [Color]
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: gradient),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.darkBrown)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}

struct ThemeOverviewView: View {
    @Binding var programs: [Program]
    @State private var expandedTheme: ProgramTheme? = nil
    
    var themesWithPrograms: [(theme: ProgramTheme, count: Int)] {
        let grouped = Dictionary(grouping: programs, by: { $0.theme })
        return ProgramTheme.allCases.compactMap { theme in
            if let programs = grouped[theme], !programs.isEmpty {
                return (theme, programs.count)
            }
            return nil
        }.sorted { $0.count > $1.count }
    }
    
    func programsForTheme(_ theme: ProgramTheme) -> [Program] {
        programs.filter { $0.theme == theme }.sorted { $0.applicationDeadline < $1.applicationDeadline }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AppHeader(title: "Programs by Theme")
                
                if themesWithPrograms.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "tag")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        Text("No themes yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 100)
                } else {
                    ForEach(themesWithPrograms, id: \.theme) { item in
                        VStack(spacing: 0) {
                            Button(action: {
                                withAnimation(.spring()) {
                                    expandedTheme = expandedTheme == item.theme ? nil : item.theme
                                }
                            }) {
                                HStack {
                                    Circle()
                                        .fill(item.theme.color)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(systemName: "tag.fill")
                                                .foregroundColor(.white)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.theme.rawValue)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.darkBrown)
                                        
                                        Text("\(item.count) program\(item.count == 1 ? "" : "s")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: expandedTheme == item.theme ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(item.theme.color)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: item.theme.color.opacity(0.2), radius: 8, y: 4)
                            }
                            .buttonStyle(.plain)
                            
                            if expandedTheme == item.theme {
                                VStack(spacing: 12) {
                                    ForEach(programsForTheme(item.theme)) { program in
                                        ProgramCard(program: program)
                                    }
                                }
                                .padding(.top, 12)
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("By Theme")
    }
}

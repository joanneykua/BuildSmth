//
//  OverviewCountryView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct OverviewCountryView: View {
    @Binding var programs: [Program]
    @State private var expandedCountry: String? = nil
    
    var countries: [String] {
        Array(Set(programs.map { $0.country })).sorted()
    }
    
    func programsForCountry(_ country: String) -> [Program] {
        programs.filter { $0.country == country }.sorted { $0.applicationDeadline < $1.applicationDeadline }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AppHeader(title: "Programs by Country")
                
                if countries.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "globe.asia.australia")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        Text("No countries yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Add programs to see countries here")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 100)
                } else {
                    ForEach(countries, id: \.self) { country in
                        let countryPrograms = programsForCountry(country)
                        
                        VStack(spacing: 0) {
                            Button(action: {
                                withAnimation(.spring()) {
                                    expandedCountry = expandedCountry == country ? nil : country
                                }
                            }) {
                                HStack {
                                    // Country flag emoji (simplified)
                                    Text(countryFlag(country))
                                        .font(.largeTitle)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(country)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.darkBrown)
                                        
                                        Text("\(countryPrograms.count) program\(countryPrograms.count == 1 ? "" : "s")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: expandedCountry == country ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.vibrantBlue)
                                }
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white, Color.softGray.opacity(0.5)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
                            }
                            .buttonStyle(.plain)
                            
                            if expandedCountry == country {
                                VStack(spacing: 12) {
                                    ForEach(countryPrograms) { program in
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
    }
    
    func countryFlag(_ country: String) -> String {
        let flagMap: [String: String] = [
            "United States": "🇺🇸",
            "United Kingdom": "🇬🇧",
            "Canada": "🇨🇦",
            "Australia": "🇦🇺",
            "Germany": "🇩🇪",
            "France": "🇫🇷",
            "Netherlands": "🇳🇱",
            "Switzerland": "🇨🇭",
            "Singapore": "🇸🇬",
            "Japan": "🇯🇵",
            "South Korea": "🇰🇷",
            "China": "🇨🇳",
            "Sweden": "🇸🇪",
            "Denmark": "🇩🇰",
            "Norway": "🇳🇴",
            "Spain": "🇪🇸",
            "Italy": "🇮🇹",
            "Austria": "🇦🇹",
            "Belgium": "🇧🇪",
            "Ireland": "🇮🇪",
            "New Zealand": "🇳🇿",
            "India": "🇮🇳",
            "Israel": "🇮🇱",
            "UAE": "🇦🇪",
            "South Africa": "🇿🇦"
        ]
        return flagMap[country] ?? "🌍"
    }
}

struct ProgramCard: View {
    let program: Program
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(program.theme.color)
                    .frame(width: 5, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(program.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Circle()
                            .fill(program.theme.color)
                            .frame(width: 8, height: 8)
                        Text(program.theme.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Image(systemName: program.isVirtual ? "network" : "location.fill")
                    .foregroundColor(.vibrantPurple)
                    .font(.caption)
                Text(program.isVirtual ? "Virtual" : program.city)
                    .font(.subheadline)
            }
            
            HStack {
                Image(systemName: "calendar.badge.exclamationmark")
                    .foregroundColor(.red)
                    .font(.caption)
                Text("Deadline:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(program.applicationDeadline, style: .date)
                    .font(.subheadline)
            }
            
            if let start = program.startDate {
                HStack {
                    Image(systemName: "calendar.badge.clock")
                        .foregroundColor(.vibrantBlue)
                        .font(.caption)
                    Text("Start:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(start, style: .date)
                        .font(.subheadline)
                }
            }
            
            if !program.requirements.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    Text("Requirements:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    ForEach(program.requirements.prefix(3), id: \.self) { req in
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.vibrantGreen)
                                .font(.caption)
                            Text(req)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    if program.requirements.count > 3 {
                        Text("+ \(program.requirements.count - 3) more")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
            }
            
            if !program.website.isEmpty {
                Divider()
                if let url = URL(string: program.website) {
                    Link(destination: url) {
                        HStack {
                            Image(systemName: "link")
                                .font(.caption)
                            Text("Visit Website")
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                        .foregroundColor(.vibrantBlue)
                        .padding(8)
                        .background(Color.vibrantBlue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
    }
}

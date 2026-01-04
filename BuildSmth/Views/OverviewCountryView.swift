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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                AppHeader(title: "Overview by Country")
                
                ForEach(countries, id: \.self) { country in
                    card {
                        VStack {
                            HStack {
                                Text(country).bold()
                                Spacer()
                                Button(action: {
                                    expandedCountry = expandedCountry == country ? nil : country
                                }) {
                                    Image(systemName: expandedCountry == country ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.burntOrange)
                                }
                            }
                            
                            if expandedCountry == country {
                                ForEach(programs.filter { $0.country == country }) { program in
                                    VStack(alignment: .leading) {
                                        Text(program.name).bold()
                                        Text("City: \(program.city)")
                                        Text("Theme: \(program.theme.rawValue)")
                                        Text("Deadline: \(program.applicationDeadline, style: .date)")
                                    }
                                    .padding(.leading, 16)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

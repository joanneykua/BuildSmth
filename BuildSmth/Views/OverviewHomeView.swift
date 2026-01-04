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
        VStack(spacing: 20) {
            AppHeader(title: "Overview")
            
            NavigationLink {
                OverviewCountryView(programs: $programs)
            } label: {
                card {
                    HStack {
                        Image(systemName: "globe")
                        Text("By Country")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
            }
            
            NavigationLink {
                MonthCalendarView(programs: $programs)
            } label: {
                card {
                    HStack {
                        Image(systemName: "calendar")
                        Text("By Month")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
            }
        }
        .padding()
    }
}

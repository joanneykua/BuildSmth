//
//  OverviewHomeView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct OverviewHomeView: View {
    let programs: [Program]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                NavigationLink("By Tag") {
                    TagOverviewView(programs: programs)
                }
                NavigationLink("By Month") {
                    MonthCalendarView(programs: programs)
                }
            }
            .padding()
            .navigationTitle("Overview")
        }
    }
}

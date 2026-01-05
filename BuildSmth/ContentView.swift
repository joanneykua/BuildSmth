//
//  ContentView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct ContentView: View {
    @State private var programs: [Program] = Storage.loadPrograms()
    @State private var editingProgram: Program? = nil
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AddProgramView(programs: $programs, editingProgram: $editingProgram)
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
                .tag(0)
            
            ProgramListView(programs: $programs, editingProgram: $editingProgram, selectedTab: $selectedTab)
                .tabItem {
                    Label("Programs", systemImage: "list.bullet")
                }
                .tag(1)
            
            OverviewHomeView(programs: $programs)
                .tabItem {
                    Label("Overview", systemImage: "chart.bar.fill")
                }
                .tag(2)
        }
        .accentColor(.vibrantBlue)
        .onChange(of: programs) { newValue in
            Storage.savePrograms(newValue)
        }
    }
}


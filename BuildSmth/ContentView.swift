//
//  ContentView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct ContentView: View {
    @State private var programs: [Program] = Storage.loadPrograms()
    
    var body: some View {
        TabView {
            AddProgramView(programs: $programs)
                .tabItem { Label("Add Program", systemImage: "plus") }
            
            ProgramListView(programs: $programs)
                .tabItem { Label("All Programs", systemImage: "list.bullet") }
            
            OverviewHomeView(programs: $programs)
                .tabItem { Label("Overview", systemImage: "square.grid.2x2") }
        }
    }
}


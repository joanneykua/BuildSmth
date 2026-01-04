//
//  ContentView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct ContentView: View {
    @State private var programs: [Program] = loadPrograms()
    
    var body: some View {
        TabView {
            AddProgramView(programs: $programs)
                .tabItem { Label("Add", systemImage: "plus") }
            
            ProgramListView(programs: $programs)
                .tabItem { Label("Programs", systemImage: "list.bullet") }
            
            OverviewHomeView(programs: programs)
                .tabItem { Label("Overview", systemImage: "chart.pie") }
        }
        .accentColor(.ink)
        .background(Color.canvas.ignoresSafeArea())
    }
}


//
//  ProgramListView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct ProgramListView: View {
    @Binding var programs: [Program]
    
    var sorted: [Program] {
        programs.sorted { $0.applicationDeadline < $1.applicationDeadline }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(sorted) { program in
                        card {
                            HStack {
                                Text(program.name)
                                    .font(.headline)
                                Spacer()
                                Text(program.applicationDeadline, style: .date)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("All Programs")
        }
    }
}


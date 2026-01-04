//
//  AddProgramView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct AddProgramView: View {
    @Binding var programs: [Program]
    
    @State private var name = ""
    @State private var requirementsText = ""
    @State private var deadline = Date()
    @State private var period = ""
    @State private var location = ""
    @State private var theme: ProgramTheme = .other
    @State private var tagsText = ""
    @State private var website = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    card {
                        TextField("Program name", text: $name)
                        Divider()
                        TextEditor(text: $requirementsText)
                            .frame(height: 120)
                            .overlay(
                                Text("One requirement per line")
                                    .foregroundColor(.gray)
                                    .opacity(0.4),
                                alignment: .topLeading
                            )
                    }
                    
                    card {
                        DatePicker("Application deadline", selection: $deadline, displayedComponents: .date)
                        TextField("Program period", text: $period)
                        TextField("Location", text: $location)
                    }
                    
                    card {
                        Picker("Theme", selection: $theme) {
                            ForEach(ProgramTheme.allCases, id: \.self) {
                                Text($0.rawValue.capitalized)
                            }
                        }
                        TextField("Tags (comma separated)", text: $tagsText)
                        TextField("Website link", text: $website)
                    }
                    
                    Button("Save Program") {
                        let program = Program(
                            name: name,
                            requirements: requirementsText.components(separatedBy: "\n"),
                            applicationDeadline: deadline,
                            programPeriod: period,
                            location: location,
                            theme: theme,
                            participantLimit: nil,
                            website: website,
                            tags: tagsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                        )
                        programs.append(program)
                        savePrograms(programs)
                        name = ""
                        requirementsText = ""
                        period = ""
                        location = ""
                        tagsText = ""
                        website = ""
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.moss)
                    .cornerRadius(14)
                }
                .padding()
            }
            .navigationTitle("Add Program")
        }
    }
}

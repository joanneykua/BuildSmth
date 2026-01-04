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
    @State private var requirements: [String] = []
    @State private var requirementText = ""
    @State private var applicationDeadline = Date()
    @State private var startDate: Date?
    @State private var endDate: Date?
    
    @State private var isVirtual = false
    @State private var selectedCountry = "Australia"
    @State private var selectedCity = "Sydney"
    @State private var selectedTheme: ProgramTheme = .computerScience
    @State private var website = ""
    
    @State private var editProgramID: UUID? = nil
    
    let countriesWithCities: [String: [String]] = [
        "Australia": ["Sydney", "Melbourne", "Canberra"],
        "China": ["Beijing", "Shanghai", "Guangzhou"],
        "Japan": ["Tokyo", "Kyoto", "Osaka"],
        "Singapore": ["Singapore"],
        "South Korea": ["Seoul", "Busan"]
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AppHeader(title: editProgramID == nil ? "Add Program" : "Edit Program")
                
                TextField("Program Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Add requirement", text: $requirementText)
                        Button(action: addRequirement) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.burntOrange)
                        }
                    }
                    ForEach(requirements, id: \.self) { req in
                        HStack {
                            Text("• \(req)")
                            Spacer()
                            Button(action: { removeRequirement(req) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                
                DatePicker("Application Deadline", selection: $applicationDeadline, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Start Date
                    HStack {
                        Text("Start Date:")
                            .bold()
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { startDate ?? Date() },
                                set: { startDate = $0 }
                            ),
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .frame(maxWidth: 200)
                        
                        // Clear button
                        if startDate != nil {
                            Button(action: { startDate = nil }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    // End Date
                    HStack {
                        Text("End Date:")
                            .bold()
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { endDate ?? Date() },
                                set: { endDate = $0 }
                            ),
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .frame(maxWidth: 200)
                        
                        // Clear button
                        if endDate != nil {
                            Button(action: { endDate = nil }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }

                
                Toggle("Virtual / Online", isOn: $isVirtual)
                
                HStack {
                    Picker("Country", selection: $selectedCountry) {
                        ForEach(Array(countriesWithCities.keys), id: \.self) { Text($0) }
                    }
                    Picker("City", selection: $selectedCity) {
                        ForEach(countriesWithCities[selectedCountry] ?? [], id: \.self) { Text($0) }
                    }
                }
                .disabled(isVirtual)
                
                Picker("Theme", selection: $selectedTheme) {
                    ForEach(ProgramTheme.allCases, id: \.self) { Text($0.rawValue) }
                }
                
                TextField("Website", text: $website)
                    .textFieldStyle(.roundedBorder)
                
                HStack(spacing: 16) {
                    Button("Save") { saveProgram() }
                        .padding()
                        .background(Color.burntOrange)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    
                    Button("Discard") { resetForm() }
                        .padding()
                        .background(Color.lightBeige)
                        .foregroundColor(.darkBrown)
                        .cornerRadius(14)
                }
                
            }
            .padding()
        }
    }
    
    func addRequirement() {
        guard !requirementText.isEmpty else { return }
        requirements.append(requirementText)
        requirementText = ""
    }
    
    func removeRequirement(_ req: String) {
        requirements.removeAll { $0 == req }
    }
    
    func saveProgram() {
        let program = Program(
            id: editProgramID ?? UUID(),
            name: name,
            requirements: requirements,
            applicationDeadline: applicationDeadline,
            startDate: startDate,
            endDate: endDate,
            country: selectedCountry,
            city: selectedCity,
            isVirtual: isVirtual,
            theme: selectedTheme,
            website: website
        )
        
        if let idx = programs.firstIndex(where: { $0.id == editProgramID }) {
            programs[idx] = program
        } else {
            programs.append(program)
        }
        Storage.savePrograms(programs)
        resetForm()
    }
    
    func resetForm() {
        name = ""
        requirements = []
        requirementText = ""
        applicationDeadline = Date()
        startDate = nil
        endDate = nil
        selectedCountry = "Australia"
        selectedCity = "Sydney"
        selectedTheme = .computerScience
        isVirtual = false
        website = ""
        editProgramID = nil
    }
}

//
//  AddProgramView.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

struct AddProgramView: View {
    @Binding var programs: [Program]
    @Binding var editingProgram: Program?
    
    @State private var name = ""
    @State private var requirements: [String] = []
    @State private var requirementText = ""
    @State private var applicationDeadline = Date()
    @State private var startDate: Date?
    @State private var endDate: Date?
    
    @State private var isVirtual = false
    @State private var selectedCountry = "United States"
    @State private var selectedCity = "New York"
    @State private var selectedTheme: ProgramTheme = .computerScience
    @State private var website = ""
    
    @State private var showSuccessAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AppHeader(title: editingProgram == nil ? "Add New Program" : "Edit Program")
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Program Name
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "book.fill")
                                .foregroundColor(.darkBrown)
                            Text("Program Name")
                                .font(.headline)
                                .foregroundColor(.darkBrown)
                        }
                        TextField("e.g., Summer Research Internship", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: .infinity)
                    }
                    
                    // MARK: Theme
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "tag.fill")
                                .foregroundColor(.darkBrown)
                            Text("Theme")
                                .font(.headline)
                                .foregroundColor(.darkBrown)
                        }
                        
                        Picker("Theme", selection: $selectedTheme) {
                            ForEach(ProgramTheme.allCases, id: \.self) { theme in
                                HStack {
                                    Circle()
                                        .fill(theme.color)
                                        .frame(width: 12, height: 12)
                                    Text(theme.rawValue)
                                }
                                .tag(theme)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                    }
                    
                    // MARK: Requirements
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "checklist")
                                .foregroundColor(.darkBrown)
                            Text("Requirements")
                                .font(.headline)
                                .foregroundColor(.darkBrown)
                        }
                        
                        HStack {
                            TextField("Add requirement", text: $requirementText)
                                .textFieldStyle(.roundedBorder)
                            Button(action: addRequirement) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.vibrantGreen)
                            }
                        }
                        
                        if !requirements.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(requirements, id: \.self) { req in
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.vibrantBlue)
                                        Text(req)
                                            .font(.body)
                                        Spacer()
                                        Button(action: { removeRequirement(req) }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(8)
                                    .background(Color.softGray)
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // MARK: Important Dates
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundColor(.darkBrown)
                            Text("Important Dates")
                                .font(.headline)
                                .foregroundColor(.darkBrown)
                        }
                        
                        VStack(spacing: 10) {
                            // Application Deadline
                            HStack {
                                Text("Application Deadline")
                                    .fontWeight(.medium)
                                Spacer()
                                DatePicker("", selection: $applicationDeadline, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding(12)
                            .background(Color.vibrantOrange.opacity(0.15))
                            .cornerRadius(10)
                            
                            // Start Date
                            HStack {
                                Text("Start Date")
                                    .fontWeight(.medium)
                                Spacer()
                                DatePicker("", selection: Binding(
                                    get: { startDate ?? Date() },
                                    set: { startDate = $0 }
                                ), displayedComponents: .date)
                                .labelsHidden()
                                
                                if startDate != nil {
                                    Button(action: { startDate = nil }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color.vibrantBlue.opacity(0.15))
                            .cornerRadius(10)
                            
                            // End Date
                            HStack {
                                Text("End Date")
                                    .fontWeight(.medium)
                                Spacer()
                                DatePicker("", selection: Binding(
                                    get: { endDate ?? Date() },
                                    set: { endDate = $0 }
                                ), displayedComponents: .date)
                                .labelsHidden()
                                
                                if endDate != nil {
                                    Button(action: { endDate = nil }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color.vibrantPurple.opacity(0.15))
                            .cornerRadius(10)
                        }
                    }
                    
                    // MARK: Location
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.darkBrown)
                            Text("Location")
                                .font(.headline)
                                .foregroundColor(.darkBrown)
                        }
                        
                        Toggle(isOn: $isVirtual) {
                            HStack {
                                Image(systemName: "network")
                                    .foregroundColor(.vibrantPurple)
                                Text("Virtual / Online Program")
                            }
                        }
                        .padding(12)
                        .background(Color.softGray)
                        .cornerRadius(10)
                        
                        if !isVirtual {
                            HStack(spacing: 12) {
                                Picker("Country", selection: $selectedCountry) {
                                    ForEach(Array(LocationData.countriesWithCities.keys.sorted()), id: \.self) { country in
                                        Text(country).tag(country)
                                    }
                                }
                                .pickerStyle(.menu)
                                .onChange(of: selectedCountry) { _ in
                                    if let cities = LocationData.countriesWithCities[selectedCountry],
                                       !cities.isEmpty {
                                        selectedCity = cities[0]
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                                Picker("City", selection: $selectedCity) {
                                    ForEach(LocationData.countriesWithCities[selectedCountry] ?? [], id: \.self) { city in
                                        Text(city).tag(city)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    
                    // MARK: Website
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "link")
                                .foregroundColor(.darkBrown)
                            Text("Website (Optional)")
                                .font(.headline)
                                .foregroundColor(.darkBrown)
                        }
                        TextField("https://example.com", text: $website)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .frame(maxWidth: .infinity)
                    }
                    
                    // MARK: Action Buttons
                    HStack(spacing: 16) {
                        Button(action: saveProgram) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text(editingProgram == nil ? "Save" : "Update")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.vibrantGreen, Color.vibrantBlue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }
                        
                        Button(action: resetForm) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Clear")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.lightBeige)
                            .foregroundColor(.darkBrown)
                            .cornerRadius(14)
                        }
                    }
                    .padding(.top, 10)
                    
                } // VStack(alignment: .leading)
                .padding()
            }
            .padding(.horizontal)
        }
        .alert("Success!", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(editingProgram == nil ? "Program added successfully!" : "Program updated successfully!")
        }
        .onAppear {
            loadEditingProgram()
        }
        .onChange(of: editingProgram) { _ in
            loadEditingProgram()
        }
    }
    
    // MARK: - Helper Methods
    
    func loadEditingProgram() {
        guard let program = editingProgram else { return }
        name = program.name
        requirements = program.requirements
        applicationDeadline = program.applicationDeadline
        startDate = program.startDate
        endDate = program.endDate
        selectedCountry = program.country
        selectedCity = program.city
        isVirtual = program.isVirtual
        selectedTheme = program.theme
        website = program.website
    }
    
    func addRequirement() {
        let trimmed = requirementText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        requirements.append(trimmed)
        requirementText = ""
    }
    
    func removeRequirement(_ req: String) {
        requirements.removeAll { $0 == req }
    }
    
    func saveProgram() {
        guard !name.isEmpty else { return }
        
        let program = Program(
            id: editingProgram?.id ?? UUID(),
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
        
        if let idx = programs.firstIndex(where: { $0.id == program.id }) {
            programs[idx] = program
        } else {
            programs.append(program)
        }
        Storage.savePrograms(programs)
        showSuccessAlert = true
        resetForm()
    }
    
    func resetForm() {
        name = ""
        requirements = []
        requirementText = ""
        applicationDeadline = Date()
        startDate = nil
        endDate = nil
        selectedCountry = "United States"
        selectedCity = "New York"
        selectedTheme = .computerScience
        isVirtual = false
        website = ""
        editingProgram = nil
    }
}

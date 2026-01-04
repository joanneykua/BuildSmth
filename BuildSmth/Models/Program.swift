//
//  Program.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

enum ProgramTheme: String, CaseIterable, Codable {
    case physics, engineering, computerScience = "Computer Science", mathematics, biology, chemistry, business, arts, socialScience = "Social Science", law, medicine, psychology
}

struct Program: Identifiable, Codable, Equatable {
    var id = UUID()
    
    var name: String
    var requirements: [String]
    var applicationDeadline: Date
    var startDate: Date?
    var endDate: Date?
    var hasStartDate: Bool { startDate != nil }
    var hasEndDate: Bool { endDate != nil }
    
    var country: String
    var city: String
    var isVirtual: Bool
    var theme: ProgramTheme
    var website: String
}

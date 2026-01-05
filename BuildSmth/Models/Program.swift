//
//  Program.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/5.
//

import SwiftUI

enum ProgramTheme: String, CaseIterable, Codable {
    case physics = "Physics"
    case engineering = "Engineering"
    case computerScience = "Computer Science"
    case mathematics = "Mathematics"
    case biology = "Biology"
    case chemistry = "Chemistry"
    case business = "Business"
    case arts = "Arts"
    case socialScience = "Social Science"
    case law = "Law"
    case medicine = "Medicine"
    case psychology = "Psychology"
    case other = "Other"
    case interdisciplinary = "Interdesciplinary"
    
    var color: Color {
        switch self {
        case .physics: return Color(red: 0.2, green: 0.4, blue: 0.8)
        case .engineering: return Color(red: 0.9, green: 0.5, blue: 0.2)
        case .computerScience: return Color(red: 0.3, green: 0.7, blue: 0.5)
        case .mathematics: return Color(red: 0.7, green: 0.3, blue: 0.7)
        case .biology: return Color(red: 0.4, green: 0.8, blue: 0.3)
        case .chemistry: return Color(red: 0.8, green: 0.6, blue: 0.2)
        case .business: return Color(red: 0.2, green: 0.6, blue: 0.8)
        case .arts: return Color(red: 0.9, green: 0.4, blue: 0.6)
        case .socialScience: return Color(red: 0.6, green: 0.5, blue: 0.8)
        case .law: return Color(red: 0.5, green: 0.3, blue: 0.2)
        case .medicine: return Color(red: 0.8, green: 0.2, blue: 0.3)
        case .psychology: return Color(red: 0.4, green: 0.6, blue: 0.7)
        case .other: return Color.gray
        case .interdisciplinary: return Color.yellow
        }
    }
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
    
    var isStarred: Bool = false
    
    func formattedText() -> String {
        var text = """
        Program: \(name)
        Theme: \(theme.rawValue)
        Location: \(isVirtual ? "Virtual/Online" : "\(city), \(country)")
        Application Deadline: \(applicationDeadline.formatted(date: .long, time: .omitted))
        """
        
        if let start = startDate {
            text += "\nStart Date: \(start.formatted(date: .long, time: .omitted))"
        }
        
        if let end = endDate {
            text += "\nEnd Date: \(end.formatted(date: .long, time: .omitted))"
        }
        
        if !requirements.isEmpty {
            text += "\nRequirements:\n"
            for req in requirements {
                text += "  • \(req)\n"
            }
        }
        
        if !website.isEmpty {
            text += "Website: \(website)\n"
        }
        
        return text + "\n---\n"
    }
}

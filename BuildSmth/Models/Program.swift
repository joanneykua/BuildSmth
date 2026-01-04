//
//  Program.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import Foundation

enum ProgramTheme: String, Codable, CaseIterable {
    case physics, cs, math, engineering, interdisciplinary, other
}

struct Program: Identifiable, Codable {
    var id = UUID()
    var name: String
    var requirements: [String]
    var applicationDeadline: Date
    var programPeriod: String
    var location: String
    var theme: ProgramTheme
    var participantLimit: Int?
    var website: String
    var tags: [String]
}

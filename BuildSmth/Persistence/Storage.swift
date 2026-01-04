//
//  Storage.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import Foundation

struct Storage {
    static let key = "programs"

    static func savePrograms(_ programs: [Program]) {
        if let data = try? JSONEncoder().encode(programs) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func loadPrograms() -> [Program] {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Program].self, from: data) {
            return decoded
        }
        return []
    }
}

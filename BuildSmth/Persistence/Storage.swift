//
//  Storage.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import Foundation

func savePrograms(_ programs: [Program]) {
    if let data = try? JSONEncoder().encode(programs) {
        UserDefaults.standard.set(data, forKey: "programs")
    }
}

func loadPrograms() -> [Program] {
    if let data = UserDefaults.standard.data(forKey: "programs"),
       let decoded = try? JSONDecoder().decode([Program].self, from: data) {
        return decoded
    }
    return []
}

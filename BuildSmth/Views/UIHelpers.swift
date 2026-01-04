//
//  UIHelpers.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

// Colors
extension Color {
    static let canvas = Color(red: 236/255, green: 232/255, blue: 226/255)
    static let ink = Color(red: 38/255, green: 50/255, blue: 60/255)
    static let moss = Color(red: 170/255, green: 190/255, blue: 180/255)
    static let clay = Color(red: 210/255, green: 190/255, blue: 180/255)
}

// Card View Modifier
func card<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
    content()
        .padding()
        .background(Color.white.opacity(0.7))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
}

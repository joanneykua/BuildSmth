//
//  UIHelpers.swift
//  BuildSmth
//
//  Created by Joanne Kuang on 2026/1/4.
//

import SwiftUI

extension Color {
    static let burntOrange = Color(red: 187/255, green: 108/255, blue: 67/255)
    static let darkBrown = Color(red: 74/255, green: 65/255, blue: 60/255)
    static let softGray = Color(red: 235/255, green: 239/255, blue: 238/255)
    static let sand = Color(red: 200/255, green: 144/255, blue: 109/255)
    static let lightBeige = Color(red: 204/255, green: 180/255, blue: 153/255)
}

func card<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
    content()
        .padding()
        .background(Color.softGray)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
}

struct AppHeader: View {
    var title: String
    var body: some View {
        ZStack {
            Text(title)
                .font(.system(.title2, design: .rounded))
                .foregroundColor(.darkBrown)
        }
        .frame(height: 60)
    }
}

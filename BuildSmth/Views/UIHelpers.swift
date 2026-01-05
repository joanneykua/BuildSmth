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
    
    // New vibrant colors
    static let vibrantBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    static let vibrantGreen = Color(red: 0.3, green: 0.8, blue: 0.5)
    static let vibrantPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let vibrantPink = Color(red: 0.9, green: 0.4, blue: 0.7)
    static let vibrantOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
}

func card<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
    content()
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.softGray.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
}

struct AppHeader: View {
    var title: String
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.vibrantPink.opacity(0.8), Color.vibrantBlue]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 70)
            .cornerRadius(15)
            
            Text(title)
                .font(.system(.title, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(height: 70)
        .shadow(color: .black.opacity(0.15), radius: 5, y: 3)
    }
}

// Location data
struct LocationData {
    static let countriesWithCities: [String: [String]] = [
        "United States": ["New York", "Boston", "San Francisco", "Los Angeles", "Chicago", "Seattle", "Austin", "Philadelphia", "San Diego", "Washington DC", "Other"],
        "United Kingdom": ["London", "Oxford", "Cambridge", "Edinburgh", "Manchester", "Bristol", "Other"],
        "Canada": ["Toronto", "Vancouver", "Montreal", "Ottawa", "Calgary", "Other"],
        "Australia": ["Sydney", "Melbourne", "Canberra", "Brisbane", "Perth", "Other"],
        "Germany": ["Berlin", "Munich", "Hamburg", "Frankfurt", "Cologne", "Other"],
        "France": ["Paris", "Lyon", "Marseille", "Toulouse", "Nice", "Other"],
        "Netherlands": ["Amsterdam", "Rotterdam", "The Hague", "Utrecht", "Other"],
        "Switzerland": ["Zurich", "Geneva", "Bern", "Basel", "Other"],
        "Singapore": ["Singapore"],
        "Japan": ["Tokyo", "Kyoto", "Osaka", "Yokohama", "Fukuoka", "Other"],
        "South Korea": ["Seoul", "Busan", "Incheon", "Other"],
        "China": ["Beijing", "Shanghai", "Guangzhou", "Shenzhen", "Hong Kong", "Other"],
        "Sweden": ["Stockholm", "Gothenburg", "Malmö", "Other"],
        "Denmark": ["Copenhagen", "Aarhus", "Other"],
        "Norway": ["Oslo", "Bergen", "Other"],
        "Spain": ["Madrid", "Barcelona", "Valencia", "Seville", "Other"],
        "Italy": ["Rome", "Milan", "Florence", "Venice", "Bologna", "Other"],
        "Austria": ["Vienna", "Salzburg", "Innsbruck", "Other"],
        "Belgium": ["Brussels", "Antwerp", "Ghent", "Other"],
        "Ireland": ["Dublin", "Cork", "Galway", "Other"],
        "New Zealand": ["Auckland", "Wellington", "Christchurch", "Other"],
        "India": ["Mumbai", "Delhi", "Bangalore", "Hyderabad", "Chennai", "Other"],
        "Israel": ["Tel Aviv", "Jerusalem", "Haifa", "Other"],
        "UAE": ["Dubai", "Abu Dhabi", "Other"],
        "South Africa": ["Cape Town", "Johannesburg", "Durban", "Other"],
        "Other": ["Other"]
    ]
}

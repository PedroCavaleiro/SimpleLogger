//
//  CustomPreFilledComponents.swift
//  SimpleLogger Examples
//
//  Created by Pedro Cavaleiro on 14/09/2025.
//

import SwiftUI
import SimpleLoggerUI

// MARK: - Example 1: Card-style Component
struct CardStylePreFilledComponent: View {
    let key: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(key)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
            
            Text(value)
                .font(.body)
                .foregroundStyle(.secondary)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(6)
        }
    }
}

// MARK: - Example 2: Colored Badge Component
struct BadgeStylePreFilledComponent: View {
    let key: String
    let value: String
    
    var body: some View {
        HStack {
            Text(key)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue)
                .cornerRadius(12)
        }
    }
}

// MARK: - Example 3: Icon-based Component
struct IconStylePreFilledComponent: View {
    let key: String
    let value: String
    
    private func iconForKey(_ key: String) -> String {
        switch key.lowercased() {
        case let k where k.contains("version"):
            return "number.circle.fill"
        case let k where k.contains("device"):
            return "iphone"
        case let k where k.contains("os"):
            return "gear.circle.fill"
        default:
            return "info.circle.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconForKey(key))
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(key)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
    }
}

// MARK: - Usage Examples
@MainActor
struct CustomPreFilledComponentExamples {
    
    // Example 1: Using Card Style
    static var cardStyleConfig: ReporterViewConfiguration {
        ReporterViewConfiguration(
            preFilledData: [
                "App Version": "1.2.3",
                "iOS Version": "17.0",
                "Device Model": "iPhone 15 Pro"
            ],
            preFilledDataComponentBuilder: { key, value in
                AnyView(CardStylePreFilledComponent(key: key, value: value))
            }
        )
    }
    
    // Example 2: Using Badge Style
    static var badgeStyleConfig: ReporterViewConfiguration {
        ReporterViewConfiguration(
            preFilledData: [
                "Build": "Debug",
                "Environment": "Development",
                "User Type": "Premium"
            ],
            preFilledDataComponentBuilder: { key, value in
                AnyView(BadgeStylePreFilledComponent(key: key, value: value))
            }
        )
    }
    
    // Example 3: Using Icon Style
    static var iconStyleConfig: ReporterViewConfiguration {
        ReporterViewConfiguration(
            preFilledData: [
                "App Version": "2.1.0",
                "Device Model": "iPhone 15 Pro Max",
                "iOS Version": "17.0.1",
                "Memory Usage": "245 MB"
            ],
            preFilledDataComponentBuilder: { key, value in
                AnyView(IconStylePreFilledComponent(key: key, value: value))
            }
        )
    }
    
    // Example 4: Inline Custom Component (no separate struct needed)
    static var inlineCustomConfig: ReporterViewConfiguration {
        ReporterViewConfiguration(
            preFilledData: [
                "Session ID": "abc123def456",
                "Last Action": "Button Tap",
                "Error Count": "0"
            ],
            preFilledDataComponentBuilder: { key, value in
                AnyView(
                    HStack {
                        Text("•")
                            .foregroundColor(.orange)
                            .fontWeight(.bold)
                        
                        Text(key)
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text(value)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 6)
                            .background(Color(.systemGray5))
                            .cornerRadius(4)
                    }
                )
            }
        )
    }
}

// MARK: - Preview Examples
#Preview("Card Style") {
    ReporterFormView(
        issueText: .constant("Sample bug description"),
        configuration: CustomPreFilledComponentExamples.cardStyleConfig
    )
}

#Preview("Badge Style") {
    ReporterFormView(
        issueText: .constant("Sample bug description"),
        configuration: CustomPreFilledComponentExamples.badgeStyleConfig
    )
}

#Preview("Icon Style") {
    ReporterFormView(
        issueText: .constant("Sample bug description"),
        configuration: CustomPreFilledComponentExamples.iconStyleConfig
    )
}

#Preview("Inline Custom") {
    ReporterFormView(
        issueText: .constant("Sample bug description"),
        configuration: CustomPreFilledComponentExamples.inlineCustomConfig
    )
}

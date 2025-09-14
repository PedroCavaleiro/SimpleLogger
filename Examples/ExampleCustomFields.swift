//
//  ExampleCustomFields.swift
//  SimpleLogger
//
//  Created by Pedro Cavaleiro on 14/09/2025.
//

import SwiftUI
import SimpleLoggerUI

// Example implementation of a custom text field
struct EmailFormField: CustomFormField {
    @State private var email: String = ""
    
    var fieldKey: String { "email" }
    var fieldValue: String { email }
    
    var body: some View {
        HStack {
            Text("Email")
            Spacer()
            TextField("your@email.com", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
        }
    }
}

// Example implementation of a picker field
struct PriorityFormField: CustomFormField {
    @State private var selectedPriority = "Medium"
    private let priorities = ["Low", "Medium", "High", "Critical"]
    
    var fieldKey: String { "priority" }
    var fieldValue: String { selectedPriority }
    
    var body: some View {
        HStack {
            Text("Priority")
            Spacer()
            Picker("Priority", selection: $selectedPriority) {
                ForEach(priorities, id: \.self) { priority in
                    Text(priority).tag(priority)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

// Example implementation of a toggle field
struct IncludeLogsFormField: CustomFormField {
    @State private var includeLogs: Bool = true
    
    var fieldKey: String { "include_logs" }
    var fieldValue: String { includeLogs ? "true" : "false" }
    
    var body: some View {
        HStack {
            Text("Include Logs")
            Spacer()
            Toggle("", isOn: $includeLogs)
        }
    }
}

// Example usage in a parent view
struct ExampleReporterView: View {
    @State private var issueText = ""
    
    var body: some View {
        let config = ReporterViewConfiguration(
            customFields: [
                CustomFormFieldWrapper(field: EmailFormField()),
                CustomFormFieldWrapper(field: PriorityFormField()),
                CustomFormFieldWrapper(field: IncludeLogsFormField())
            ]
        )
        
        VStack {
            ReporterFormView(issueText: $issueText, configuration: config)
            
            Button("Submit Report") {
                // Get all form values
                let customFieldValues = config.getCustomFieldValues()
                print("Issue Text: \(issueText)")
                print("Custom Fields: \(customFieldValues)")
                // Submit the report with both issueText and customFieldValues
            }
            .padding()
        }
    }
}
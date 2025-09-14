# SimpleLogger

A comprehensive, lightweight Swift logging utility designed for iOS applications with file-based persistence, structured logging, and automatic log management.

## Features

- 🗂️ **File-Based Persistence**: Automatic JSON-based log storage with organized file structure
- 📊 **Structured Logging**: Comprehensive log entries with source tracking (file, function, line)
- 🔍 **Five-Tier Severity Levels**: Debug, Info, Warning, Error, and Critical classifications
- 📦 **Object Logging**: Built-in support for logging `Codable` objects alongside messages
- 🔄 **Automatic Log Rotation**: Intelligent file size management (10MB limit) with oldest entry cleanup
- 📸 **Environment Snapshots**: Capture complete application state for debugging
- 📈 **Log Analytics**: Statistical summaries and level-based counting for log files
- 🧵 **Thread-Safe**: Main actor isolation ensures safe concurrent access
- 🧹 **Log Management**: Individual file deletion and bulk cleanup operations
- 📱 **SwiftUI Bug Reporter**: Ready-to-use UI components for in-app bug reporting

## Installation

### Swift Package Manager

Add SimpleLogger to your project through Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/PedroCavaleiro/SimpleLogger`
3. Click Add Package

Or add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/PedroCavaleiro/SimpleLogger", from: "1.0.0")
]
```

## Quick Start

```swift
import SimpleLogger

// Simple text logging
SimpleLogger.log("Application started")

// Logging with custom severity level
SimpleLogger.log("User authentication failed", level: .error)

// Logging with structured data
let user = User(id: 123, name: "John Doe")
SimpleLogger.log("User logged in", user, level: .info)

// Environment snapshot for debugging
SimpleLogger.snapshot(appState, settingsManager, networkConfig)
```

## Usage

### Basic Logging

```swift
// Different severity levels
SimpleLogger.log("Debug information", level: .debug)
SimpleLogger.log("General information", level: .info)
SimpleLogger.log("Potentially harmful situation", level: .warning)
SimpleLogger.log("Error occurred", level: .error)
SimpleLogger.log("Critical system failure", level: .critical)
```

### Structured Object Logging

```swift
struct APIResponse: Codable {
    let status: Int
    let message: String
}

let response = APIResponse(status: 200, message: "Success")
SimpleLogger.log("API call completed", response, level: .info)
```

### Environment Snapshots

Capture comprehensive application state for debugging:

```swift
SimpleLogger.snapshot(
    applicationState,
    userPreferences,
    networkConfiguration,
    databaseState
)
```

### Log File Management

```swift
// Get log file statistics
let stats = SimpleLogger.logFileStats()
print("Total files: \(stats.fileCount), Total size: \(stats.totalSize) bytes")

// List all log files with analysis
let summaries = SimpleLogger.listLogFiles()
for summary in summaries {
    print("File: \(summary.fileName)")
    print("Size: \(summary.size) bytes")
    print("Last modified: \(summary.lastModified)")
    print("Log levels: \(summary.levelCounts)")
}

// Load specific log file entries
let entries = SimpleLogger.loadLogEntries(fromFileNamed: "ViewController")

// Clean up logs
SimpleLogger.deleteLogFile(named: "OldController")
SimpleLogger.clearLogs() // Delete all log files
```

## SimpleLoggerUI - Bug Reporting Interface

The SimpleLoggerUI target provides ready-to-use SwiftUI components for implementing in-app bug reporting functionality. These components automatically integrate with SimpleLogger's file system to include log files and device information in bug reports.

### Features

- 📝 **Pre-built Bug Report Form**: Complete SwiftUI form with customizable sections
- 🔧 **Configurable Interface**: Customize headers, footers, placeholders, and button text
- 📊 **Automatic Data Collection**: Include device info, app version, and OS details
- 🗂️ **Log File Integration**: Automatically attach log files to bug reports
- 🎨 **Custom Form Fields**: Add your own input fields (email, category, etc.)
- 📸 **State Snapshots**: Capture application state when reports are sent
- 🌐 **Localization Ready**: All text supports localization
- 🎯 **Flexible Presentation**: Use in navigation stacks, sheets, or full-screen covers

### Basic Usage

Import both SimpleLogger and SimpleLoggerUI:

```swift
import SimpleLogger
import SimpleLoggerUI
```

#### Simple Bug Report Form

```swift
import SwiftUI
import SimpleLoggerUI

struct ContentView: View {
    @State private var showingBugReport = false
    
    var body: some View {
        Button("Report Bug") {
            showingBugReport = true
        }
        .sheet(isPresented: $showingBugReport) {
            let config = ReporterViewConfiguration(
                navigationBarTitle: "Report Issue",
                sendAction: { issueText, preFilledData, customFields, logInfo in
                    // Handle bug report submission
                    submitBugReport(
                        description: issueText,
                        deviceInfo: preFilledData,
                        additionalFields: customFields,
                        logs: logInfo.1
                    )
                    showingBugReport = false
                }
            )
            ReporterFormNavWrapper(configuration: config)
        }
    }
}
```

#### Advanced Configuration with Custom Fields

```swift
struct BugReportView: View {
    @State private var showingReport = false
    
    var body: some View {
        Button("Advanced Bug Report") {
            showingReport = true
        }
        .fullScreenCover(isPresented: $showingReport) {
            let config = ReporterViewConfiguration(
                navigationBarTitle: "Submit Feedback",
                bgSectionHeader: "What went wrong?",
                bgSectionFooter: "Please describe the issue in detail so we can help you better.",
                showPrefilledDataSection: true,
                showLogFilesInformation: true,
                customFields: [
                    CustomFormFieldWrapper(field: EmailFormField()),
                    CustomFormFieldWrapper(field: CategoryFormField())
                ],
                sendAction: { issueText, preFilledData, customFields, logInfo in
                    // Send to your bug tracking system
                    BugTracker.submit(
                        description: issueText,
                        userEmail: customFields["email"] ?? "",
                        category: customFields["category"] ?? "General",
                        deviceInfo: preFilledData,
                        logFiles: logInfo.1
                    )
                    showingReport = false
                },
                sendButtonText: "Submit Report",
                snapshotObjects: [AppState.shared, UserSettings.shared]
            )
            ReporterFormNavWrapper(configuration: config)
        }
    }
}
```

### Components

#### ReporterFormView

The main bug reporting form view that can be used within existing navigation contexts:

```swift
// Use when you already have a NavigationStack
ReporterFormView(configuration: config)
```

#### ReporterFormNavWrapper  

A convenience wrapper that provides its own NavigationStack - perfect for sheets and full-screen covers:

```swift
// Use for modal presentations
ReporterFormNavWrapper(configuration: config)
```

#### ReporterViewConfiguration

The configuration object that controls all aspects of the bug report form:

```swift
let config = ReporterViewConfiguration(
    navigationBarTitle: "Report Bug",
    bgSectionHeader: "Describe the Issue",
    showPrefilledDataSection: true,
    includeAppVersion: true,
    includeDeviceModel: true,
    includeDeviceOS: true,
    sendAction: { issueText, preFilledData, customFields, logInfo in
        // Your custom submission logic here
    }
)
```

### Custom Form Fields

Create custom input fields by conforming to the `CustomFormField` protocol:

```swift
struct PriorityFormField: CustomFormField {
    @State private var selectedPriority = "Medium"
    let priorities = ["Low", "Medium", "High", "Critical"]
    
    var key: String { "priority" }
    
    var view: AnyView {
        AnyView(
            Picker("Priority", selection: $selectedPriority) {
                ForEach(priorities, id: \.self) { priority in
                    Text(priority)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        )
    }
    
    func getValue() -> String {
        return selectedPriority
    }
}
```

### Integration with Bug Tracking Systems

The `sendAction` closure provides all collected data for integration with your preferred bug tracking system:

```swift
sendAction: { issueText, preFilledData, customFields, logInfo in
    // Example: GitHub Issues
    GitHubAPI.createIssue(
        title: "Bug Report",
        body: """
        **Description:** \(issueText)
        
        **Device Info:**
        \(preFilledData.map { "\($0.key): \($0.value)" }.joined(separator: "\n"))
        
        **Additional Fields:**
        \(customFields.map { "\($0.key): \($0.value)" }.joined(separator: "\n"))
        """,
        attachments: logInfo.1
    )
    
    // Example: JIRA
    JiraAPI.createTicket(
        summary: "User Reported Issue",
        description: issueText,
        customFields: customFields,
        attachments: [logInfo.1]
    )
    
    // Example: Email
    EmailComposer.send(
        to: "support@yourapp.com",
        subject: "Bug Report",
        body: issueText,
        attachments: [logInfo.1]
    )
}
```

### Automatic Data Collection

The bug reporter automatically collects and includes:

- **App Version**: From bundle info
- **Device Model**: iPhone/iPad model (requires DeviceKit)
- **OS Version**: iOS version
- **Log Files**: All SimpleLogger log files
- **Timestamps**: When the report was created
- **Custom Data**: Any additional fields you configure

### Requirements for UI Components

- iOS 13.0+
- Swift 5.0+
- SwiftUI framework
- SimpleLogger framework

## Log Levels

| Level | Description | Use Case |
|-------|-------------|----------|
| `debug` | Detailed development information | Development debugging, verbose tracing |
| `info` | General application flow | Normal application operations, milestones |
| `warning` | Potentially harmful situations | Deprecated API usage, configuration issues |
| `error` | Error conditions affecting functionality | Recoverable errors, API failures |
| `critical` | Severe errors that may cause failure | System crashes, unrecoverable errors |

## Log File Organization

- **Automatic Organization**: Logs are organized by source file (e.g., `ViewController.swift.json`)
- **JSON Format**: Structured JSON storage for easy parsing and analysis
- **Size Management**: Automatic rotation when files exceed 10MB
- **Document Directory**: Stored in app's document directory under `logging/` folder

## Type Aliases

For cleaner code, consider creating a type alias:

```swift
typealias Logger = SimpleLogger

// Now you can use:
Logger.log("Much cleaner!", level: .info)
```

## Log Entry Structure

Each log entry contains:

```swift
{
    "message": "Your log message",
    "objectName": "OptionalObjectType",
    "objectData": "JSON representation of logged object",
    "level": "INFO",
    "isSnapshot": false,
    "file": "/path/to/SourceFile.swift",
    "function": "functionName()",
    "line": 42,
    "timestamp": "2024-01-15T10:30:00Z"
}
```

## Best Practices

1. **Use Appropriate Log Levels**: Choose the right severity level for each message
2. **Leverage Object Logging**: Log structured data for better debugging context
3. **Regular Cleanup**: Periodically clear old logs to manage storage
4. **Snapshots for Complex State**: Use environment snapshots for multi-component debugging
5. **Type Aliases**: Create shorter aliases for frequent use

## Requirements

- iOS 13.0+
- Swift 5.0+
- Foundation framework

## Documentation

Full API documentation is available at: **https://pedrocavaleiro.github.io/SimpleLogger/**

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the terms included in the LICENSE file.

---

Built with ❤️ by [Pedro Cavaleiro](https://github.com/PedroCavaleiro)

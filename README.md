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
SimpleLogger.log("Potential issue detected", level: .warning)
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

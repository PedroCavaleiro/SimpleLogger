//
//  ReporterViewConfiguration.swift
//  SimpleLogger
//
//  Created by Pedro Cavaleiro on 14/09/2025.
//

import Foundation
import SwiftUI

#if canImport(DeviceKit)
import DeviceKit
#endif
#if canImport(UIKit)
import UIKit
#endif

/// A configuration class that defines the appearance and behavior of the bug reporter view.
///
/// `ReporterViewConfiguration` is an `ObservableObject` that provides comprehensive customization
/// options for the bug reporting interface. It allows you to configure section headers, footers,
/// placeholder text, pre-filled data, custom form fields, automatic device information inclusion,
/// log files information display, and send report functionality.
///
/// ## Overview
///
/// The configuration is divided into several functional areas:
/// - **Navigation and UI Text**: Customize titles, headers, and footers
/// - **Pre-filled Data**: Automatically include device and app information
/// - **Custom Form Fields**: Add additional input fields as needed
/// - **Log Files Information**: Display and include log file details
/// - **Send Report Action**: Configure report submission behavior and button text
/// - **Behavior Control**: Toggle visibility and inclusion of various sections
///
/// ## Usage
///
/// ### Basic Configuration
///
/// ```swift
/// let config = ReporterViewConfiguration(
///     navigationBarTitle: "Report Bug",
///     bgSectionHeader: "What happened?",
///     showPrefilledDataSection: true,
///     showLogFilesInformation: true,
///     sendAction: { issueText, preFilledData, customFields, logInfo in
///         // Handle the bug report submission
///         print("Issue: \(issueText)")
///         // Process the collected data and send the report
///     }
/// )
/// ```
///
/// ### Advanced Configuration with Custom Send Action
///
/// ```swift
/// let config = ReporterViewConfiguration(
///     customFields: [CustomFormFieldWrapper(field: EmailFormField())],
///     includeAppVersion: true,
///     includeDeviceModel: true,
///     showLogFilesInformation: true,
///     sendAction: { issueText, preFilledData, customFields, logStats in
///         // Custom report submission logic
///         MyBugReportAPI.submit(
///             description: issueText,
///             deviceInfo: preFilledData,
///             additionalFields: customFields,
///             logInfo: logStats
///         )
///     },
///     sendButtonText: "Submit Report"
/// )
/// ```
///
/// ## Important
/// The `sendAction` closure is required for the reporter view to function properly.
/// There is no default send report implementation - you must provide your own custom
/// action to handle report submission.
///
/// ## Topics
///
/// ### Creating a Configuration
///
/// - ``init(navigationBarTitle:bgSectionHeader:bgSectionFooter:bgPlaceholderText:showPrefilledDataSection:sendPreFilledData:preFilledDataSectionHeader:preFilledDataSectionFooter:preFilledData:preFilledDataComponentBuilder:customFields:customFieldsSectionHeader:customFieldsSectionFooter:showLogFilesInformation:logFilesInformationSectionHeader:logFilesInformationSectionFooter:logFilesInformationComponentBuilder:sendAction:sendButtonText:snapshotObjects:includeAppVersion:includeDeviceOS:includeDeviceModel:)``
///
/// ### Navigation Configuration
///
/// - ``navigationBarTitle``
///
/// ### Bug Description Section
///
/// - ``bgSectionHeader``
/// - ``bgSectionFooter``
/// - ``bgPlaceholderText``
///
/// ### Pre-filled Data Section
///
/// - ``showPrefilledDataSection``
/// - ``sendPreFilledData``
/// - ``preFilledDataSectionHeader``
/// - ``preFilledDataSectionFooter``
/// - ``preFilledData``
/// - ``preFilledDataComponentBuilder``
///
/// ### Custom Form Fields
///
/// - ``customFields``
/// - ``customFieldsSectionHeader``
/// - ``customFieldsSectionFooter``
///
/// ### Log Files Information
///
/// - ``showLogFilesInformation``
/// - ``logFilesInformationSectionHeader``
/// - ``logFilesInformationSectionFooter``
/// - ``logFilesInformationComponentBuilder``
///
/// ### Send Report Configuration
///
/// - ``sendAction``
/// - ``sendButtonText``
/// - ``snapshotObjects``
///
/// ### Data Retrieval
///
/// - ``getCustomFieldValues()``
@MainActor
public class ReporterViewConfiguration: ObservableObject {
 
    /// The title displayed in the navigation bar of the reporter view.
    ///
    /// This text appears at the top of the bug reporting interface and should clearly
    /// indicate the purpose of the view to users.
    ///
    /// ## Default Value
    /// ```swift
    /// "Report a Issue"
    /// ```
    public var navigationBarTitle: String
    
    // MARK: - Bug Description Section
    
    /// The header text for the bug description section.
    ///
    /// This text appears above the main text input area where users describe their issue.
    /// It should prompt users to provide detailed information about the problem they're experiencing.
    ///
    /// ## Default Value
    /// ```swift
    /// "Describe the issue"
    /// ```
    public var bgSectionHeader: String
    
    /// The footer text for the bug description section.
    ///
    /// This explanatory text appears below the section header to provide additional guidance
    /// to users about what kind of information they should include in their bug report.
    ///
    /// ## Default Value
    /// ```swift
    /// "Please provide a detailed description of the issue you are experiencing."
    /// ```
    public var bgSectionFooter: String
    
    /// The placeholder text displayed in the bug description text field.
    ///
    /// This text appears inside the text input field when it's empty, providing a hint
    /// about what users should enter. It disappears when the user starts typing.
    ///
    /// ## Default Value
    /// ```swift
    /// "Bug description (optional)"
    /// ```
    public var bgPlaceholderText: String
    
    // MARK: - Auto Included Data (this data is appended but not editable by the user)
    
    /// Controls whether the pre-filled data section is visible to users.
    ///
    /// When `true`, users can see the automatically collected device and app information
    /// in a dedicated section. When `false`, this section is hidden from view, though
    /// the data may still be included in the report based on ``sendPreFilledData``.
    ///
    /// ## Default Value
    /// ```swift
    /// true
    /// ```
    public var showPrefilledDataSection: Bool
    
    /// Controls whether pre-filled data is included in the bug report submission.
    ///
    /// When `true`, the automatically collected information (device model, OS version, app version)
    /// is included when the report is submitted. When `false`, only user-entered data is sent.
    ///
    /// ## Default Value
    /// ```swift
    /// true
    /// ```
    public var sendPreFilledData: Bool
    
    /// The header text for the pre-filled data section.
    ///
    /// This text appears above the list of automatically collected device and app information.
    /// It should clearly identify what type of information is being displayed.
    ///
    /// ## Default Value
    /// ```swift
    /// "Information"
    /// ```
    public var preFilledDataSectionHeader: String
    
    /// The footer text for the pre-filled data section.
    ///
    /// This explanatory text appears below the pre-filled data to inform users that
    /// this information will be automatically included in their bug report.
    ///
    /// ## Default Value
    /// ```swift
    /// "The information above is automatically included in the report."
    /// ```
    public var preFilledDataSectionFooter: String
    
    /// A dictionary containing key-value pairs of pre-filled information.
    ///
    /// This dictionary stores automatically collected device and app information that
    /// can be included in bug reports. Keys typically include "App Version", "Device Model",
    /// and "OS Version", but can be customized as needed.
    ///
    /// ## Example
    /// ```swift
    /// [
    ///     "App Version": "1.2.3",
    ///     "Device Model": "iPhone 14 Pro",
    ///     "OS Version": "16.0"
    /// ]
    /// ```
    public var preFilledData: [String: String]
    
    /// A closure that creates the visual representation for each pre-filled data item.
    ///
    /// This builder function is called for each key-value pair in ``preFilledData`` to
    /// create the SwiftUI view that displays the information. You can customize this
    /// to change how the pre-filled data appears in the interface.
    ///
    /// - Parameters:
    ///   - key: The key from the pre-filled data dictionary
    ///   - value: The corresponding value from the pre-filled data dictionary
    /// - Returns: An `AnyView` containing the visual representation
    ///
    /// ## Default Implementation
    /// ```swift
    /// { key, value in
    ///     AnyView(
    ///         PreFilledDataComponent {
    ///             Text(key)
    ///         } value: {
    ///             Text(value)
    ///                 .foregroundStyle(.secondary)
    ///                 .multilineTextAlignment(.trailing)
    ///         }
    ///     )
    /// }
    /// ```
    public var preFilledDataComponentBuilder: (String, String) -> AnyView
    
    // MARK: - Custom Form Fields
    
    /// An optional array of custom form field wrappers for additional user input.
    ///
    /// Use this property to add custom input fields to the bug report form. Each field
    /// should be wrapped in a ``CustomFormFieldWrapper`` to provide consistent access
    /// to field keys and values.
    ///
    /// When `nil`, no custom fields section is displayed. When populated, the fields
    /// are rendered in their own section with the configured headers and footers.
    ///
    /// ## Example
    /// ```swift
    /// let emailField = EmailFormField()
    /// let phoneField = PhoneFormField()
    /// customFields = [
    ///     CustomFormFieldWrapper(field: emailField),
    ///     CustomFormFieldWrapper(field: phoneField)
    /// ]
    /// ```
    public var customFields: [CustomFormFieldWrapper]?
    
    /// The header text for the custom form fields section.
    ///
    /// This text appears above any custom form fields when ``customFields`` is not empty.
    /// It should clearly indicate what additional information is being requested.
    ///
    /// ## Default Value
    /// ```swift
    /// "Additional Information"
    /// ```
    public var customFieldsSectionHeader: String
    
    /// The footer text for the custom form fields section.
    ///
    /// This explanatory text appears below the custom fields section header to provide
    /// guidance about filling in the additional fields.
    ///
    /// ## Default Value
    /// ```swift
    /// "Please fill in the fields below."
    /// ```
    public var customFieldsSectionFooter: String
    
    // MARK: - Log Information
    
    /// Controls whether the log files information section is visible to users.
    ///
    /// When `true`, users can see information about log files that will be included
    /// in their bug report. When `false`, this section is hidden from view.
    /// This section typically displays details like log file names, sizes, and dates.
    ///
    /// ## Default Value
    /// ```swift
    /// true
    /// ```
    public var showLogFilesInformation: Bool
    
    /// The header text for the log files information section.
    ///
    /// This text appears above the list of log files that will be included in the bug report.
    /// It should clearly identify what type of log information is being displayed.
    ///
    /// ## Default Value
    /// ```swift
    /// "Log Files"
    /// ```
    public var logFilesInformationSectionHeader: String
    
    /// The footer text for the log files information section.
    ///
    /// This explanatory text appears below the log files information to inform users
    /// that these log files will be automatically included in their bug report for
    /// debugging purposes.
    ///
    /// ## Default Value
    /// ```swift
    /// "The log files above are automatically included in the report."
    /// ```
    public var logFilesInformationSectionFooter: String
    

    // MARK: - Send Action
    
    /// A custom action to be executed when the send report button is tapped.
    ///
    /// This closure is called with all the collected report data when the user taps 
    /// the "Send Report" button. You must provide this closure to handle report submission,
    /// as there is no default send report implementation.
    ///
    /// The closure receives the following data:
    /// - Issue description text entered by the user
    /// - Pre-filled data dictionary (if enabled)
    /// - Custom field values dictionary
    /// - Log file information (summary and data)
    ///
    /// ## Important
    /// This property is required for the reporter view to function properly. If no custom
    /// action is provided, the send button will execute without performing any report
    /// submission.
    ///
    /// ## Example
    /// ```swift
    /// config.sendAction = { issueText, preFilledData, customFields, logInfo in
    ///     // Custom report submission logic
    ///     submitBugReport(
    ///         description: issueText,
    ///         deviceInfo: preFilledData,
    ///         additionalFields: customFields,
    ///         logData: logInfo
    ///     )
    /// }
    /// ```
    public var sendAction: ((String, [String: String], [String: String], (String, Data?)) -> Void)?
    
    /// The text displayed on the send report button in the navigation bar.
    ///
    /// This text appears on the trailing navigation bar button that users tap to
    /// submit their bug report.
    ///
    /// ## Default Value
    /// ```swift
    /// "Send"
    /// ```
    public var sendButtonText: String
    
    /// An optional array of objects to automatically snapshot when a bug report is sent.
    ///
    /// When provided, these objects will be automatically captured using the SimpleLogger's
    /// `snapshot()` function before the bug report is submitted. This allows developers to
    /// include current application state and configuration data with every bug report.
    ///
    /// All objects in the array must conform to `Codable` to be serialized and logged.
    /// The snapshots are taken immediately before calling the send action, ensuring the
    /// most current state is captured.
    ///
    /// ## Use Cases
    /// - **Application State**: Include current app configuration and user session data
    /// - **Settings Manager**: Capture user preferences and configuration settings
    /// - **Network State**: Include current API configuration and authentication state
    /// - **Custom Managers**: Snapshot any custom application managers or controllers
    ///
    /// ## Example
    /// ```swift
    /// config.snapshotObjects = [
    ///     AppStateManager.shared,
    ///     UserSettingsManager.shared,
    ///     NetworkConfigurationManager.shared,
    ///     LocationManager.shared
    /// ]
    /// ```
    ///
    /// - Note: Snapshots are logged with debug level and synthetic source information
    /// - Important: All objects must conform to `Codable` for serialization
    public var snapshotObjects: [any Codable]?

    // MARK: - Form
    
    /// Creates a new reporter view configuration with the specified options.
    ///
    /// This initializer provides comprehensive customization of the bug reporting interface,
    /// including text content, behavior settings, custom fields, automatic data collection,
    /// and log files information display. All parameters have sensible defaults, so you only
    /// need to specify the options you want to customize.
    ///
    /// - Parameters:
    ///   - navigationBarTitle: The title for the navigation bar. Defaults to "Report a Issue".
    ///   - bgSectionHeader: Header text for the bug description section. Defaults to "Describe the issue".
    ///   - bgSectionFooter: Footer text for the bug description section. Defaults to helpful instruction text.
    ///   - bgPlaceholderText: Placeholder text for the description field. Defaults to "Bug description (optional)".
    ///   - showPrefilledDataSection: Whether to show the pre-filled data section. Defaults to `true`.
    ///   - sendPreFilledData: Whether to include pre-filled data in submissions. Defaults to `true`.
    ///   - preFilledDataSectionHeader: Header for the pre-filled data section. Defaults to "Information".
    ///   - preFilledDataSectionFooter: Footer for the pre-filled data section. Defaults to explanatory text.
    ///   - preFilledData: Initial pre-filled data dictionary. Defaults to empty, but may be populated based on other parameters.
    ///   - preFilledDataComponentBuilder: Builder closure for pre-filled data views. Defaults to using ``PreFilledDataComponent``.
    ///   - customFields: Optional array of custom form fields. Defaults to `nil`.
    ///   - customFieldsSectionHeader: Header for custom fields section. Defaults to "Additional Information".
    ///   - customFieldsSectionFooter: Footer for custom fields section. Defaults to "Please fill in the fields below.".
    ///   - showLogFilesInformation: Whether to show the log files information section. Defaults to `true`.
    ///   - logFilesInformationSectionHeader: Header for log files section. Defaults to "Log Files".
    ///   - logFilesInformationSectionFooter: Footer for log files section. Defaults to explanatory text.
    ///   - includeAppVersion: Whether to automatically include app version. Defaults to `true`.
    ///   - includeDeviceOS: Whether to automatically include OS version. Defaults to `true`.
    ///   - includeDeviceModel: Whether to automatically include device model. Defaults to `true`.
    ///   - sendAction: Custom action to perform on report submission. Defaults to `nil`.
    ///   - sendButtonText: Text for the send report button. Defaults to "Send".
    ///   - snapshotObjects: Array of objects to snapshot on send. Defaults to `nil`.
    ///
    /// ## Automatic Data Collection
    ///
    /// When the corresponding include parameters are `true`, the following information is automatically collected:
    /// - **App Version**: Retrieved from the main bundle's `CFBundleShortVersionString`
    /// - **Device Model**: Retrieved using DeviceKit (if available)
    /// - **OS Version**: Retrieved from `UIDevice.current.systemVersion` (if UIKit is available)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let config = ReporterViewConfiguration(
    ///     navigationBarTitle: "Report Problem",
    ///     bgSectionHeader: "What went wrong?",
    ///     showPrefilledDataSection: true,
    ///     showLogFilesInformation: true,
    ///     includeAppVersion: true,
    ///     includeDeviceModel: false,
    ///     customFields: [
    ///         CustomFormFieldWrapper(field: EmailField()),
    ///         CustomFormFieldWrapper(field: CategoryField())
    ///     ]
    /// )
    /// ```
    public init(
        navigationBarTitle: String = "Report a Issue",
        bgSectionHeader: String = "Describe the issue",
        bgSectionFooter: String = "Please provide a detailed description of the issue you are experiencing.",
        bgPlaceholderText: String = "Bug description (optional)",
        showPrefilledDataSection: Bool = true,
        sendPreFilledData: Bool = true,
        preFilledDataSectionHeader: String = "Information",
        preFilledDataSectionFooter: String = "The information above is automatically included in the report.",
        preFilledData: [String: String] = [:],
        preFilledDataComponentBuilder: @escaping (String, String) -> AnyView = { key, value in
            AnyView(
                PreFilledDataComponent {
                    Text(key)
                } value: {
                    Text(value)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            )
        },
        customFields: [CustomFormFieldWrapper]? = nil,
        customFieldsSectionHeader: String = "Additional Information",
        customFieldsSectionFooter: String = "Please fill in the fields below.",
        showLogFilesInformation: Bool = true,
        logFilesInformationSectionHeader: String = "Log Files",
        logFilesInformationSectionFooter: String = "The log files above are automatically included in the report.",
        sendAction: ((String, [String: String], [String: String], (String, Data?)) -> Void)? = nil,
        sendButtonText: String = "Send",
        snapshotObjects: [any Codable]? = nil,
        includeAppVersion: Bool = true,
        includeDeviceOS: Bool = true,
        includeDeviceModel: Bool = true
    ) {
        self.navigationBarTitle = navigationBarTitle
        self.bgSectionHeader = bgSectionHeader
        self.bgSectionFooter = bgSectionFooter
        self.bgPlaceholderText = bgPlaceholderText
        self.showPrefilledDataSection = showPrefilledDataSection
        self.sendPreFilledData = sendPreFilledData
        self.preFilledDataSectionHeader = preFilledDataSectionHeader
        self.preFilledDataSectionFooter = preFilledDataSectionFooter
        self.preFilledData = preFilledData
        self.preFilledDataComponentBuilder = preFilledDataComponentBuilder
        self.customFields = customFields
        self.customFieldsSectionHeader = customFieldsSectionHeader
        self.customFieldsSectionFooter = customFieldsSectionFooter
        self.showLogFilesInformation = showLogFilesInformation
        self.logFilesInformationSectionHeader = logFilesInformationSectionHeader
        self.logFilesInformationSectionFooter = logFilesInformationSectionFooter
        self.sendAction = sendAction
        self.sendButtonText = sendButtonText
        self.snapshotObjects = snapshotObjects
        
        if includeAppVersion {
            self.preFilledData["App Version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
        }
        
        #if canImport(DeviceKit)
        if includeDeviceModel {
            let device = Device.current
            self.preFilledData["Device Model"] = device.description
        }
        #endif
        #if canImport(UIKit)
        if includeDeviceOS {
            self.preFilledData["OS Version"] = UIDevice.current.systemVersion
        }
        #endif
        
    }
    
    /// Retrieves the current values from all custom form fields as a dictionary.
    ///
    /// This method collects the current state of all custom form fields and returns them
    /// as a dictionary where keys are the field identifiers and values are the current
    /// field values as strings.
    ///
    /// - Returns: A dictionary mapping field keys to their current string values. Returns an empty dictionary if no custom fields are configured.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let values = config.getCustomFieldValues()
    /// print(values) // ["email": "user@example.com", "category": "Bug"]
    /// ```
    ///
    /// ## Note
    ///
    /// This method only returns values from custom fields. Pre-filled data can be accessed
    /// directly through the ``preFilledData`` property.
    public func getCustomFieldValues() -> [String: String] {
        guard let customFields = customFields else { return [:] }
        
        var values: [String: String] = [:]
        for field in customFields {
            values[field.key] = field.getValue()
        }
        return values
    }
    
}

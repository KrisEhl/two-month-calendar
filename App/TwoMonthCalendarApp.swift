import AppKit
import SwiftUI

private let calendarAppURL = URL(fileURLWithPath: "/System/Applications/Calendar.app")

/// Host app. It exists so macOS registers the widget extension. Clicking the widget
/// launches this app, which immediately hands off to Apple Calendar and quits.
@main
struct TwoMonthCalendarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        // No windows: the app is a background agent (LSUIElement) that only forwards.
        Settings { EmptyView() }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        openCalendarAndQuit()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows: Bool) -> Bool {
        openCalendarAndQuit()
        return false
    }

    private func openCalendarAndQuit() {
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = true
        NSWorkspace.shared.openApplication(at: calendarAppURL, configuration: configuration) { _, _ in
            DispatchQueue.main.async { NSApp.terminate(nil) }
        }
    }
}

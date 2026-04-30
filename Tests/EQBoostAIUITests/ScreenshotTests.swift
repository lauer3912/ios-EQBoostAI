import XCTest

class ScreenshotTests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launchEnvironment = ["DYLD_INSERT_LIBRARIES": ""]
        app.launch()
        Thread.sleep(forTimeInterval: 3.0)
    }

    private func captureScreenshot(name: String) {
        let window = app.windows.firstMatch
        let screenshot = window.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func tapTab(identifier: String) {
        let predicate = NSPredicate(format: "accessibilityIdentifier == %@", identifier)
        let button = app.buttons.matching(predicate).firstMatch
        if button.exists && button.isHittable {
            button.tap()
            Thread.sleep(forTimeInterval: 2.0)
        } else {
            print("WARNING: Could not find or tap tab: \(identifier)")
        }
    }

    // MARK: - iPhone 6.9" Screenshots

    func test01_CaptureHomeTab() throws {
        captureScreenshot(name: "01_Home")
    }

    func test02_CaptureJournalTab() throws {
        tapTab(identifier: "tab_journal")
        captureScreenshot(name: "02_Journal")
    }

    func test03_CapturePracticeTab() throws {
        tapTab(identifier: "tab_practice")
        captureScreenshot(name: "03_Practice")
    }

    func test04_CaptureTasksTab() throws {
        tapTab(identifier: "tab_tasks")
        captureScreenshot(name: "04_Tasks")
    }

    func test05_CaptureProfileTab() throws {
        tapTab(identifier: "tab_profile")
        captureScreenshot(name: "05_Profile")
    }
}
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

    func test01_CaptureHomeTab() throws {
        // Tab 1: Home - already selected by default
        captureScreenshot(name: "01_Home")
    }

    func test02_CaptureJournalTab() throws {
        // Tab 2: Journal
        if app.tabBars.buttons["Journal"].waitForExistence(timeout: 5) {
            app.tabBars.buttons["Journal"].tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        captureScreenshot(name: "02_Journal")
    }

    func test03_CaptureRolePlayTab() throws {
        // Tab 3: Practice
        if app.tabBars.buttons["Practice"].waitForExistence(timeout: 5) {
            app.tabBars.buttons["Practice"].tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        captureScreenshot(name: "03_Practice")
    }

    func test04_CaptureTasksTab() throws {
        // Tab 4: Tasks
        if app.tabBars.buttons["Tasks"].waitForExistence(timeout: 5) {
            app.tabBars.buttons["Tasks"].tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        captureScreenshot(name: "04_Tasks")
    }

    func test05_CaptureProfileTab() throws {
        // Tab 5: Profile
        if app.tabBars.buttons["Profile"].waitForExistence(timeout: 5) {
            app.tabBars.buttons["Profile"].tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        captureScreenshot(name: "05_Profile")
    }

    private func captureScreenshot(name: String) {
        if let window = app.windows.firstMatch as XCUIElement? {
            let screenshot = window.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot, quality: .medium)
            attachment.name = name
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
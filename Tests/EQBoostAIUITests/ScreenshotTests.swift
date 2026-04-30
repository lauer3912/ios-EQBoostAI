import XCTest

class ScreenshotTests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        Thread.sleep(forTimeInterval: 2.0)
    }

    func testCaptureHomeTab() throws {
        // Tab 1: Home - already selected by default
        Thread.sleep(forTimeInterval: 1.5)
        captureScreenshot(name: "01_Home")
    }

    func testCaptureJournalTab() throws {
        // Tab 2: Journal
        app.tabBars.buttons["Journal"].tap()
        Thread.sleep(forTimeInterval: 1.5)
        captureScreenshot(name: "02_Journal")
    }

    func testCaptureRolePlayTab() throws {
        // Tab 3: Practice (RolePlay)
        app.tabBars.buttons["Practice"].tap()
        Thread.sleep(forTimeInterval: 1.5)
        captureScreenshot(name: "03_Practice")
    }

    func testCaptureTasksTab() throws {
        // Tab 4: Tasks
        app.tabBars.buttons["Tasks"].tap()
        Thread.sleep(forTimeInterval: 1.5)
        captureScreenshot(name: "04_Tasks")
    }

    func testCaptureProfileTab() throws {
        // Tab 5: Profile
        app.tabBars.buttons["Profile"].tap()
        Thread.sleep(forTimeInterval: 1.5)
        captureScreenshot(name: "05_Profile")
    }

    private func captureScreenshot(name: String) {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot, quality: .medium)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
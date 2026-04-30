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
        captureScreenshot(name: "01_Home")
    }

    func test02_CaptureJournalTab() throws {
        if app.tabBars.buttons["Journal"].waitForExistence(timeout: 5) {
            app.tabBars.buttons["Journal"].tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        captureScreenshot(name: "02_Journal")
    }

    func test03_CaptureRolePlayTab() throws {
        if app.tabBars.buttons["Practice"].waitForExistence(timeout: 5) {
            app.tabBars.buttons["Practice"].tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        captureScreenshot(name: "03_Practice")
    }

    func test04_CaptureTasksTab() throws {
        if app.tabBars.buttons["Tasks"].waitForExistence(timeout: 5) {
            app.tabBars.buttons["Tasks"].tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        captureScreenshot(name: "04_Tasks")
    }

    func test05_CaptureProfileTab() throws {
        if app.tabBars.buttons["Profile"].waitForExistence(timeout: 5) {
            app.tabBars.buttons["Profile"].tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
        captureScreenshot(name: "05_Profile")
    }

    private func captureScreenshot(name: String) {
        let window = app.windows.firstMatch
        let screenshot = window.screenshot()

        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
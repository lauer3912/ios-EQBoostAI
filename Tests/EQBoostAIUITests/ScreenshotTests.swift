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

    private func tapTab(index: Int) {
        // Use tab bar buttons by index (0-based: Home=0, Journal=1, Practice=2, Tasks=3, Profile=4)
        let tabBar = app.tabBars.buttons
        if tabBar.count > index {
            tabBar.allElementsBoundByIndex[index].tap()
            Thread.sleep(forTimeInterval: 2.0)
        }
    }

    // MARK: - iPhone Screenshots

    func test01_CaptureHomeTab() throws {
        captureScreenshot(name: "01_Home")
    }

    func test02_CaptureJournalTab() throws {
        tapTab(index: 1)  // Journal = 2nd tab
        captureScreenshot(name: "02_Journal")
    }

    func test03_CapturePracticeTab() throws {
        tapTab(index: 2)  // Practice = 3rd tab
        captureScreenshot(name: "03_Practice")
    }

    func test04_CaptureTasksTab() throws {
        tapTab(index: 3)  // Tasks = 4th tab
        captureScreenshot(name: "04_Tasks")
    }

    func test05_CaptureProfileTab() throws {
        tapTab(index: 4)  // Profile = 5th tab
        captureScreenshot(name: "05_Profile")
    }
}
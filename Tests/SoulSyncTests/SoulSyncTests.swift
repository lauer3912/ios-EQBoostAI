import XCTest
@testable import SoulSync

final class SoulSyncTests: XCTestCase {

    func testEmotionEmoji() {
        XCTAssertEqual(Emotion.happy.emoji, "😊")
        XCTAssertEqual(Emotion.calm.emoji, "😌")
        XCTAssertEqual(Emotion.anxious.emoji, "😰")
    }

    func testJournalEntryCreation() {
        let entry = JournalEntry(
            text: "Test entry",
            emotions: [.happy, .calm],
            intensity: 7,
            moodScore: 85
        )
        XCTAssertEqual(entry.text, "Test entry")
        XCTAssertEqual(entry.emotions.count, 2)
        XCTAssertEqual(entry.moodScore, 85)
    }

    func testScenarioDefaults() {
        let scenario = Scenario(
            title: "Test Scenario",
            description: "A test",
            category: .jobInterview,
            difficulty: .beginner,
            duration: 10
        )
        XCTAssertEqual(scenario.title, "Test Scenario")
        XCTAssertEqual(scenario.isPremium, true)
    }

    func testTaskDefaults() {
        let task = ETask(
            title: "Test Task",
            description: "Description",
            category: .awareness,
            xpReward: 20
        )
        XCTAssertEqual(task.isCompleted, false)
        XCTAssertEqual(task.xpReward, 20)
    }
}
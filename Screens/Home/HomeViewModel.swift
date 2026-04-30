import Foundation

class HomeViewModel {

    var currentMoodScore: Int = 75
    var currentMoodEmoji: String = "😊"
    var currentMoodTitle: String = "Good"
    var streakDays: Int = 0
    var todayInsight: String?
    var weeklyMoodData: [Double] = Array(repeating: 50.0, count: 7)

    var onDataUpdate: (() -> Void)?

    private let journalService = JournalService.shared
    private let taskService = TaskService.shared

    func refreshData() {
        streakDays = taskService.getStreakDays()

        let entries = journalService.getAllEntries()
        if let latestEntry = entries.first {
            currentMoodScore = latestEntry.moodScore
            if let firstEmotion = latestEntry.emotions.first {
                currentMoodEmoji = firstEmotion.emoji
                currentMoodTitle = firstEmotion.rawValue
            }
            todayInsight = latestEntry.analysis
        } else {
            todayInsight = nil
            currentMoodScore = 75
            currentMoodEmoji = "😊"
            currentMoodTitle = "Neutral"
        }

        weeklyMoodData = journalService.getWeeklyMoodData()

        onDataUpdate?()
    }
}
import Foundation

class ProfileViewModel {

    var streakDays: Int = 0
    var journalCount: Int = 0
    var socialIQScore: Int = 50
    var level: Int = 1
    var totalXP: Int = 0
    var isPremium: Bool = false

    var onProfileUpdated: (() -> Void)?

    var settingsOptions: [String] = [
        "Dark Mode",
        "Notifications",
        "Privacy Policy",
        "Terms of Service",
        "Contact Support",
        "Rate App"
    ]

    private let journalService = JournalService.shared
    private let taskService = TaskService.shared

    func loadProfile() {
        streakDays = taskService.getStreakDays()
        journalCount = journalService.getAllEntries().count

        let entries = journalService.getAllEntries()
        if !entries.isEmpty {
            socialIQScore = entries.reduce(0) { $0 + $1.moodScore } / entries.count
            socialIQScore = min(100, max(1, socialIQScore))
        }

        onProfileUpdated?()
    }
}
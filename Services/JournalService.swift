import Foundation

class JournalService {
    static let shared = JournalService()
    private let db = DatabaseService.shared

    private init() {}

    func saveEntry(_ entry: JournalEntry) {
        db.saveJournalEntry(entry)
    }

    func getAllEntries() -> [JournalEntry] {
        return db.getAllJournalEntries()
    }

    func deleteEntry(entryId: String) {
        db.deleteJournalEntry(entryId: entryId)
    }

    func generateAIAnalysis(for text: String, emotions: [Emotion]) -> String {
        let emotionSummary = emotions.map { "\($0.emoji) \($0.rawValue)" }.joined(separator: ", ")
        let analysisTemplates = [
            "Based on your journal entry, I can see you're experiencing some \(emotions.first?.rawValue.lowercased() ?? "mixed") feelings. Your mood score is trending at \(Int.random(in: 60...85))% which shows resilience. Key insight: You tend to process emotions best when you write them down.",
            "I notice you're carrying \(emotions.first?.rawValue.lowercased() ?? "complex") energy today. This is completely normal. Your emotional awareness is growing — keep this practice up!",
            "Your writing shows strong self-awareness. The emotions you're experiencing (\(emotionSummary)) indicate you're navigating some important life moments. Remember: it's okay to feel what you feel."
        ]
        return analysisTemplates.randomElement() ?? analysisTemplates[0]
    }

    func calculateMoodScore(emotions: [Emotion], intensity: Int) -> Int {
        let baseScore: Int
        switch emotions.first {
        case .happy, .excited, .calm, .hopeful:
            baseScore = 70
        case .confused:
            baseScore = 55
        case .anxious, .sad:
            baseScore = 45
        case .angry:
            baseScore = 40
        case .none:
            baseScore = 50
        }
        let intensityMod = (intensity - 5) * 3
        return min(100, max(1, baseScore + intensityMod))
    }

    func getWeeklyMoodData() -> [Double] {
        let entries = getAllEntries()
        let calendar = Calendar.current
        var dailyAverages: [Double] = Array(repeating: 50.0, count: 7)

        for i in 0..<7 {
            let targetDate = calendar.date(byAdding: .day, value: -(6-i), to: Date())!
            let dayEntries = entries.filter { calendar.isDate($0.date, inSameDayAs: targetDate) }
            if !dayEntries.isEmpty {
                dailyAverages[i] = Double(dayEntries.reduce(0) { $0 + $1.moodScore } / dayEntries.count)
            }
        }
        return dailyAverages
    }
}
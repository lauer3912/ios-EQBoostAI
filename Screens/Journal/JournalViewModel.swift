import Foundation

class JournalViewModel {

    var entries: [JournalEntry] = []
    var selectedEmotions: [Emotion] = []
    var intensity: Int = 5
    var entryText: String = ""

    var onEntriesUpdated: (() -> Void)?

    private let journalService = JournalService.shared

    func loadEntries() {
        entries = journalService.getAllEntries()
        onEntriesUpdated?()
    }

    func toggleEmotion(_ emotion: Emotion) {
        if let index = selectedEmotions.firstIndex(of: emotion) {
            selectedEmotions.remove(at: index)
        } else {
            selectedEmotions.append(emotion)
        }
    }

    func saveEntry() {
        guard !entryText.isEmpty else { return }

        let analysis = journalService.generateAIAnalysis(for: entryText, emotions: selectedEmotions)
        let moodScore = journalService.calculateMoodScore(emotions: selectedEmotions, intensity: intensity)

        let entry = JournalEntry(
            text: entryText,
            emotions: selectedEmotions,
            intensity: intensity,
            moodScore: moodScore,
            analysis: analysis
        )

        journalService.saveEntry(entry)

        selectedEmotions = []
        intensity = 5
        entryText = ""

        loadEntries()
    }

    func deleteEntry(at index: Int) {
        let entry = entries[index]
        journalService.deleteEntry(entryId: entry.id)
        loadEntries()
    }
}
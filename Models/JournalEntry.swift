import Foundation

enum Emotion: String, CaseIterable, Codable {
    case happy = "Happy"
    case sad = "Sad"
    case anxious = "Anxious"
    case angry = "Angry"
    case calm = "Calm"
    case excited = "Excited"
    case confused = "Confused"
    case hopeful = "Hopeful"

    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .sad: return "😢"
        case .anxious: return "😰"
        case .angry: return "😠"
        case .calm: return "😌"
        case .excited: return "🤩"
        case .confused: return "😕"
        case .hopeful: return "🌟"
        }
    }

    var color: String {
        switch self {
        case .happy: return "#34D399"
        case .sad: return "#60A5FA"
        case .anxious: return "#FBBF24"
        case .angry: return "#F87171"
        case .calm: return "#4ECDC4"
        case .excited: return "#FF6B9D"
        case .confused: return "#A78BFA"
        case .hopeful: return "#6C63FF"
        }
    }
}

struct JournalEntry: Codable, Identifiable {
    let id: String
    var text: String
    var emotions: [Emotion]
    var intensity: Int
    var date: Date
    var moodScore: Int
    var analysis: String?

    init(id: String = UUID().uuidString, text: String, emotions: [Emotion], intensity: Int, date: Date = Date(), moodScore: Int = 50, analysis: String? = nil) {
        self.id = id
        self.text = text
        self.emotions = emotions
        self.intensity = intensity
        self.date = date
        self.moodScore = moodScore
        self.analysis = analysis
    }
}
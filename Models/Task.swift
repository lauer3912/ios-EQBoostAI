import Foundation

enum TaskCategory: String, CaseIterable, Codable {
    case awareness = "Awareness"
    case communication = "Communication"
    case empathy = "Empathy"
    case boundaries = "Boundaries"
    case selfRegulation = "Self-Regulation"

    var icon: String {
        switch self {
        case .awareness: return "eye.fill"
        case .communication: return "bubble.left.fill"
        case .empathy: return "heart.fill"
        case .boundaries: return "shield.fill"
        case .selfRegulation: return "leaf.fill"
        }
    }

    var color: String {
        switch self {
        case .awareness: return "#6C63FF"
        case .communication: return "#4ECDC4"
        case .empathy: return "#FF6B9D"
        case .boundaries: return "#FBBF24"
        case .selfRegulation: return "#34D399"
        }
    }
}

struct ETask: Codable, Identifiable {
    let id: String
    var title: String
    var description: String
    var category: TaskCategory
    var xpReward: Int
    var isCompleted: Bool
    var date: Date
    var difficulty: Int

    init(id: String = UUID().uuidString, title: String, description: String, category: TaskCategory, xpReward: Int, isCompleted: Bool = false, date: Date = Date(), difficulty: Int = 1) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.xpReward = xpReward
        self.isCompleted = isCompleted
        self.date = date
        self.difficulty = difficulty
    }
}

struct UserProfile: Codable {
    var streakDays: Int
    var totalXP: Int
    var level: Int
    var socialIQScore: Int
    var focusAreas: [String]
    var isPremium: Bool
    var lastJournalDate: Date?
    var journalCount: Int

    init(streakDays: Int = 0, totalXP: Int = 0, level: Int = 1, socialIQScore: Int = 50, focusAreas: [String] = [], isPremium: Bool = false, lastJournalDate: Date? = nil, journalCount: Int = 0) {
        self.streakDays = streakDays
        self.totalXP = totalXP
        self.level = level
        self.socialIQScore = socialIQScore
        self.focusAreas = focusAreas
        self.isPremium = isPremium
        self.lastJournalDate = lastJournalDate
        self.journalCount = journalCount
    }
}
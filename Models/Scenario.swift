import Foundation

enum ScenarioCategory: String, CaseIterable, Codable {
    case jobInterview = "Job Interview"
    case difficultConversation = "Difficult Conversation"
    case firstDate = "Dating"
    case conflictResolution = "Conflict Resolution"
    case publicSpeaking = "Public Speaking"
    case networking = "Networking"
    case familyDrama = "Family Drama"
    case friendDrama = "Friend Drama"

    var icon: String {
        switch self {
        case .jobInterview: return "briefcase.fill"
        case .difficultConversation: return "bubble.left.and.bubble.right.fill"
        case .firstDate: return "heart.fill"
        case .conflictResolution: return "hand.raised.fill"
        case .publicSpeaking: return "mic.fill"
        case .networking: return "person.3.fill"
        case .familyDrama: return "house.fill"
        case .friendDrama: return "person.2.fill"
        }
    }
}

enum ScenarioDifficulty: String, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var color: String {
        switch self {
        case .beginner: return "#34D399"
        case .intermediate: return "#FBBF24"
        case .advanced: return "#F87171"
        }
    }
}

struct Scenario: Codable, Identifiable {
    let id: String
    var title: String
    var description: String
    var category: ScenarioCategory
    var difficulty: ScenarioDifficulty
    var duration: Int
    var turns: Int
    var isPremium: Bool
    var iconName: String
    var conversationHistory: [ConversationMessage]
    var feedback: String?

    init(id: String = UUID().uuidString, title: String, description: String, category: ScenarioCategory, difficulty: ScenarioDifficulty, duration: Int, turns: Int = 8, isPremium: Bool = true, iconName: String = "bubble.left.and.bubble.right.fill", conversationHistory: [ConversationMessage] = [], feedback: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.difficulty = difficulty
        self.duration = duration
        self.turns = turns
        self.isPremium = isPremium
        self.iconName = iconName
        self.conversationHistory = conversationHistory
        self.feedback = feedback
    }
}

struct ConversationMessage: Codable {
    var role: String
    var content: String
    var timestamp: Date

    init(role: String, content: String, timestamp: Date = Date()) {
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}
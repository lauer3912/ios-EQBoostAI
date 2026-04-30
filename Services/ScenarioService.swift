import Foundation

enum ScenarioFilter {
    case all, free, premium
}

class ScenarioService {
    static let shared = ScenarioService()

    private init() {}

    func getAllScenarios() -> [Scenario] {
        return [
            Scenario(
                id: "1",
                title: "Job Interview Confidence",
                description: "Practice answering tough interview questions with a hiring manager.",
                category: .jobInterview,
                difficulty: .beginner,
                duration: 10,
                turns: 6,
                isPremium: false,
                iconName: "briefcase.fill"
            ),
            Scenario(
                id: "2",
                title: "Asking for a Raise",
                description: "Roleplay a conversation with your boss about compensation.",
                category: .jobInterview,
                difficulty: .advanced,
                duration: 15,
                turns: 8,
                isPremium: true,
                iconName: "dollarsign.circle.fill"
            ),
            Scenario(
                id: "3",
                title: "Difficult Feedback",
                description: "Practice receiving constructive criticism without getting defensive.",
                category: .difficultConversation,
                difficulty: .intermediate,
                duration: 10,
                turns: 6,
                isPremium: false,
                iconName: "bubble.left.and.bubble.right.fill"
            ),
            Scenario(
                id: "4",
                title: "First Date Chat",
                description: "Navigate the early stages of romantic connection.",
                category: .firstDate,
                difficulty: .beginner,
                duration: 12,
                turns: 8,
                isPremium: false,
                iconName: "heart.fill"
            ),
            Scenario(
                id: "5",
                title: "Breaking Up Respectfully",
                description: "Practice ending a relationship with compassion.",
                category: .firstDate,
                difficulty: .advanced,
                duration: 15,
                turns: 10,
                isPremium: true,
                iconName: "heart.slash.fill"
            ),
            Scenario(
                id: "6",
                title: "Resolving Family Conflict",
                description: "Navigate a tense conversation with a family member.",
                category: .familyDrama,
                difficulty: .intermediate,
                duration: 12,
                turns: 8,
                isPremium: false,
                iconName: "house.fill"
            ),
            Scenario(
                id: "7",
                title: "Public Speaking",
                description: "Practice giving a short presentation and handling Q&A.",
                category: .publicSpeaking,
                difficulty: .intermediate,
                duration: 10,
                turns: 5,
                isPremium: true,
                iconName: "mic.fill"
            ),
            Scenario(
                id: "8",
                title: "Networking at Events",
                description: "Practice starting conversations with strangers.",
                category: .networking,
                difficulty: .beginner,
                duration: 8,
                turns: 6,
                isPremium: false,
                iconName: "person.3.fill"
            ),
            Scenario(
                id: "9",
                title: "Friend Drama Resolution",
                description: "Address a misunderstanding with a close friend.",
                category: .friendDrama,
                difficulty: .intermediate,
                duration: 12,
                turns: 8,
                isPremium: true,
                iconName: "person.2.fill"
            ),
            Scenario(
                id: "10",
                title: "Setting Boundaries",
                description: "Practice saying no without guilt.",
                category: .conflictResolution,
                difficulty: .intermediate,
                duration: 10,
                turns: 6,
                isPremium: true,
                iconName: "shield.fill"
            )
        ]
    }

    func getScenariosByCategory(_ category: ScenarioCategory) -> [Scenario] {
        return getAllScenarios().filter { $0.category == category }
    }

    func getFreeScenarios() -> [Scenario] {
        return getAllScenarios().filter { !$0.isPremium }
    }

    func generateAIResponse(userMessage: String, scenario: Scenario) -> String {
        let responses = [
            "That's a thoughtful response. Let me ask you this — how did that make you feel?",
            "I appreciate your honesty. In real situations, vulnerability can be powerful.",
            "Good approach! You might also consider acknowledging the other person's perspective.",
            "Interesting choice. Remember, active listening is just as important as speaking.",
            "You're doing great! Practice makes permanent. Keep going!",
            "Consider this: What outcome are you hoping for? Is that realistic?",
            "That's a very empathetic response. Well done!",
            "You handled that smoothly. One tip: sometimes silence is powerful too."
        ]
        return responses.randomElement() ?? responses[0]
    }

    func generateFeedback(conversation: [ConversationMessage]) -> String {
        let feedbackTemplates = [
            "You showed excellent active listening skills and maintained composure throughout. Key strength: emotional awareness. Area to improve: try asking more open-ended questions to deepen the conversation.",
            "Great job staying calm under pressure. You demonstrated good boundary-setting. Improvement opportunity: practice more reflective responses to show you're truly hearing the other person.",
            "Your empathy levels were high throughout. You successfully navigated a tricky conversation while staying authentic to yourself."
        ]
        return feedbackTemplates.randomElement() ?? feedbackTemplates[0]
    }
}
import Foundation

class TaskService {
    static let shared = TaskService()
    private let db = DatabaseService.shared

    private init() {}

    func getDailyTasks() -> [ETask] {
        let existingTasks = db.getTasksForDate(Date())
        if !existingTasks.isEmpty {
            return existingTasks
        }

        let tasks = generateDailyTasks()
        tasks.forEach { db.saveTask($0) }
        return tasks
    }

    private func generateDailyTasks() -> [ETask] {
        let allTasks = [
            ETask(title: "Morning Check-In", description: "Write 3 words describing how you feel right now.", category: .awareness, xpReward: 10, difficulty: 1),
            ETask(title: "Deep Listening", description: "Have a conversation today where you fully focus on listening without planning your response.", category: .communication, xpReward: 25, difficulty: 2),
            ETask(title: "Empathy Note", description: "Write a quick note to someone who helped you recently, thanking them specifically.", category: .empathy, xpReward: 20, difficulty: 2),
            ETask(title: "Boundary Practice", description: "Say no to one request today without over-explaining or apologizing.", category: .boundaries, xpReward: 30, difficulty: 3),
            ETask(title: "Body Scan", description: "Take 5 minutes to do a body scan meditation. Notice where you're holding tension.", category: .selfRegulation, xpReward: 15, difficulty: 1),
            ETask(title: "Emotion Journal", description: "Write about a recent situation that triggered a strong emotional response.", category: .awareness, xpReward: 20, difficulty: 2),
            ETask(title: "I-Statement Practice", description: "Use 'I feel' instead of 'you make me feel' in a conversation today.", category: .communication, xpReward: 25, difficulty: 2),
            ETask(title: "Perspective Switch", description: "Think about a conflict from the other person's viewpoint. Write 3 sentences as if you were them.", category: .empathy, xpReward: 30, difficulty: 3),
            ETask(title: "Gratitude Moment", description: "Share one specific thing you appreciate about yourself today.", category: .selfRegulation, xpReward: 15, difficulty: 1),
            ETask(title: "Stress Response", description: "When you feel stressed today, pause and take 3 deep breaths before reacting.", category: .selfRegulation, xpReward: 20, difficulty: 2),
            ETask(title: "Assertive Request", description: "Make one clear, direct request of someone today — be specific about what you need.", category: .communication, xpReward: 25, difficulty: 2),
            ETask(title: "Reflect on Limits", description: "Identify one boundary you need to communicate better. Write how you'll express it.", category: .boundaries, xpReward: 20, difficulty: 2)
        ]

        return Array(allTasks.shuffled().prefix(5))
    }

    func completeTask(_ task: ETask) -> Int {
        var updatedTask = task
        updatedTask.isCompleted = true
        db.saveTask(updatedTask)
        return task.xpReward
    }

    func calculateLevel(xp: Int) -> Int {
        return (xp / 100) + 1
    }

    func getStreakDays() -> Int {
        return UserDefaults.standard.integer(forKey: "streakDays")
    }

    func updateStreak() {
        let lastDate = UserDefaults.standard.object(forKey: "lastActiveDate") as? Date ?? Date.distantPast
        let calendar = Calendar.current

        if calendar.isDateInYesterday(lastDate) || calendar.isDateInToday(lastDate) {
            if calendar.isDateInToday(lastDate) == false {
                let currentStreak = getStreakDays()
                UserDefaults.standard.set(currentStreak + 1, forKey: "streakDays")
            }
        } else {
            UserDefaults.standard.set(1, forKey: "streakDays")
        }
        UserDefaults.standard.set(Date(), forKey: "lastActiveDate")
    }
}
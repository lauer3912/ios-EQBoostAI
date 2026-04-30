import Foundation

class TasksViewModel {

    var tasks: [ETask] = []
    var earnedXP: Int = 0
    var streakDays: Int = 0

    var onTasksUpdated: (() -> Void)?

    private let taskService = TaskService.shared

    func loadTasks() {
        tasks = taskService.getDailyTasks()
        streakDays = taskService.getStreakDays()
        earnedXP = 0
        onTasksUpdated?()
    }

    func completeTask(at index: Int) {
        let task = tasks[index]
        let xpEarned = taskService.completeTask(task)
        earnedXP += xpEarned

        tasks[index].isCompleted = true

        taskService.updateStreak()
        streakDays = taskService.getStreakDays()

        onTasksUpdated?()
    }
}
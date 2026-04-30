import Foundation

class DatabaseService {
    static let shared = DatabaseService()

    private let journalEntriesKey = "journal_entries"
    private let tasksKey = "tasks"
    private let userProfileKey = "user_profile"

    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {}

    // MARK: - Journal Operations

    func saveJournalEntry(_ entry: JournalEntry) {
        var entries = getAllJournalEntries()
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        } else {
            entries.append(entry)
        }
        saveJournalEntries(entries)
    }

    func getAllJournalEntries() -> [JournalEntry] {
        guard let data = defaults.data(forKey: journalEntriesKey) else { return [] }
        do {
            let entries = try decoder.decode([JournalEntry].self, from: data)
            return entries.sorted { $0.date > $1.date }
        } catch {
            return []
        }
    }

    private func saveJournalEntries(_ entries: [JournalEntry]) {
        do {
            let data = try encoder.encode(entries)
            defaults.set(data, forKey: journalEntriesKey)
        } catch {
            print("Save journal error: \(error)")
        }
    }

    func deleteJournalEntry(entryId: String) {
        var entries = getAllJournalEntries()
        entries.removeAll { $0.id == entryId }
        saveJournalEntries(entries)
    }

    // MARK: - Task Operations

    func saveTask(_ task: ETask) {
        var tasks = getAllTasks()
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
        saveTasks(tasks)
    }

    func getAllTasks() -> [ETask] {
        guard let data = defaults.data(forKey: tasksKey) else { return [] }
        do {
            return try decoder.decode([ETask].self, from: data)
        } catch {
            return []
        }
    }

    func getTasksForDate(_ date: Date) -> [ETask] {
        return getAllTasks().filter { !$0.isCompleted }
    }

    private func saveTasks(_ tasks: [ETask]) {
        do {
            let data = try encoder.encode(tasks)
            defaults.set(data, forKey: tasksKey)
        } catch {
            print("Save task error: \(error)")
        }
    }

    func markTaskCompleted(taskId: String) {
        var tasks = getAllTasks()
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            var task = tasks[index]
            task.isCompleted = true
            tasks[index] = task
            saveTasks(tasks)
        }
    }

    // MARK: - User Profile

    func saveUserProfile(_ profile: UserProfile) {
        do {
            let data = try encoder.encode(profile)
            defaults.set(data, forKey: userProfileKey)
        } catch {
            print("Save profile error: \(error)")
        }
    }

    func getUserProfile() -> UserProfile {
        guard let data = defaults.data(forKey: userProfileKey) else {
            return UserProfile()
        }
        do {
            return try decoder.decode(UserProfile.self, from: data)
        } catch {
            return UserProfile()
        }
    }
}
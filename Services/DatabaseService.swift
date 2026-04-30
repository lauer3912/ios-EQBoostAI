import Foundation
import SQLite

class DatabaseService {
    static let shared = DatabaseService()

    private var db: Connection?

    private let journalEntries = Table("journal_entries")
    private let tasks = Table("tasks")
    private let scenarios = Table("scenarios")

    private let id = Expression<String>("id")
    private let text = Expression<String>("text")
    private let emotions = Expression<String>("emotions")
    private let intensity = Expression<Int>("intensity")
    private let date = Expression<Date>("date")
    private let moodScore = Expression<Int>("mood_score")
    private let analysis = Expression<String?>("analysis")

    private let title = Expression<String>("title")
    private let description = Expression<String>("description")
    private let category = Expression<String>("category")
    private let difficulty = Expression<String>("difficulty")
    private let duration = Expression<Int>("duration")
    private let turns = Expression<Int>("turns")
    private let isPremium = Expression<Bool>("is_premium")
    private let iconName = Expression<String>("icon_name")
    private let conversationHistory = Expression<String>("conversation_history")
    private let feedback = Expression<String?>("feedback")

    private let taskTitle = Expression<String>("task_title")
    private let taskDescription = Expression<String>("task_description")
    private let taskCategory = Expression<String>("task_category")
    private let xpReward = Expression<Int>("xp_reward")
    private let isCompleted = Expression<Bool>("is_completed")
    private let taskDate = Expression<Date>("task_date")
    private let difficultyLevel = Expression<Int>("difficulty")

    private init {
        setupDatabase()
    }

    private func setupDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/soulsync.sqlite3")
            createTables()
        } catch {
            print("Database connection error: \(error)")
        }
    }

    private func createTables() {
        do {
            try db?.run(journalEntries.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(text)
                t.column(emotions)
                t.column(intensity)
                t.column(date)
                t.column(moodScore)
                t.column(analysis)
            })

            try db?.run(tasks.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(taskTitle)
                t.column(taskDescription)
                t.column(taskCategory)
                t.column(xpReward)
                t.column(isCompleted)
                t.column(taskDate)
                t.column(difficultyLevel)
            })
        } catch {
            print("Table creation error: \(error)")
        }
    }

    // MARK: - Journal Operations

    func saveJournalEntry(_ entry: JournalEntry) {
        do {
            let emotionsString = entry.emotions.map { $0.rawValue }.joined(separator: ",")
            try db?.run(journalEntries.insert(or: .replace,
                id <- entry.id,
                text <- entry.text,
                emotions <- emotionsString,
                intensity <- entry.intensity,
                date <- entry.date,
                moodScore <- entry.moodScore,
                analysis <- entry.analysis
            ))
        } catch {
            print("Save journal error: \(error)")
        }
    }

    func getAllJournalEntries() -> [JournalEntry] {
        var entries: [JournalEntry] = []
        do {
            for row in try db!.prepare(journalEntries.order(date.desc)) {
                let emotionStrings = row[emotions].split(separator: ",").map { String($0) }
                let entryEmotions = emotionStrings.compactMap { Emotion(rawValue: $0) }
                let entry = JournalEntry(
                    id: row[id],
                    text: row[text],
                    emotions: entryEmotions,
                    intensity: row[intensity],
                    date: row[date],
                    moodScore: row[moodScore],
                    analysis: row[analysis]
                )
                entries.append(entry)
            }
        } catch {
            print("Fetch journal error: \(error)")
        }
        return entries
    }

    func deleteJournalEntry(entryId: String) {
        do {
            let entry = journalEntries.filter(id == entryId)
            try db?.run(entry.delete())
        } catch {
            print("Delete journal error: \(error)")
        }
    }

    // MARK: - Task Operations

    func saveTask(_ task: ETask) {
        do {
            try db?.run(tasks.insert(or: .replace,
                id <- task.id,
                taskTitle <- task.title,
                taskDescription <- task.description,
                taskCategory <- task.category.rawValue,
                xpReward <- task.xpReward,
                isCompleted <- task.isCompleted,
                taskDate <- task.date,
                difficultyLevel <- task.difficulty
            ))
        } catch {
            print("Save task error: \(error)")
        }
    }

    func getTasksForDate(_ date: Date) -> [ETask] {
        var taskList: [ETask] = []
        let calendar = Calendar.current
        do {
            for row in try db!.prepare(tasks.filter(isCompleted == false)) {
                if let cat = TaskCategory(rawValue: row[taskCategory]) {
                    let task = ETask(
                        id: row[id],
                        title: row[taskTitle],
                        description: row[taskDescription],
                        category: cat,
                        xpReward: row[xpReward],
                        isCompleted: row[isCompleted],
                        date: row[taskDate],
                        difficulty: row[difficultyLevel]
                    )
                    taskList.append(task)
                }
            }
        } catch {
            print("Fetch tasks error: \(error)")
        }
        return taskList
    }

    func markTaskCompleted(taskId: String) {
        do {
            let task = tasks.filter(id == taskId)
            try db?.run(task.update(isCompleted <- true))
        } catch {
            print("Mark task error: \(error)")
        }
    }
}
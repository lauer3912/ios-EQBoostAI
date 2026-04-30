import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private let viewModel = HomeViewModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // Header
    private let headerView = UIView()
    private let greetingLabel = UILabel()
    private let dateLabel = UILabel()

    // Mood Ring Card
    private let moodCard = UIView()
    private let moodRingContainer = UIView()
    private let moodEmojiLabel = UILabel()
    private let moodScoreLabel = UILabel()
    private let moodTitleLabel = UILabel()
    private let moodSubtitleLabel = UILabel()

    // Stats Row
    private let statsStack = UIStackView()

    // Quick Actions
    private let quickActionsLabel = UILabel()
    private let quickActionsStack = UIStackView()

    // Weekly Chart Card
    private let weeklyCard = UIView()
    private let weeklyTitleLabel = UILabel()
    private let weeklyBarsContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        viewModel.refreshData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.backgroundDark

        setupScrollView()
        setupHeader()
        setupMoodCard()
        setupStatsRow()
        setupQuickActions()
        setupWeeklyCard()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.showsVerticalScrollIndicator = false

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
        contentView.backgroundColor = Theme.Colors.backgroundDark
    }

    private func setupHeader() {
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }

        greetingLabel.font = Theme.Font.largeTitle()
        greetingLabel.textColor = Theme.Colors.textPrimary
        greetingLabel.text = getGreeting()
        headerView.addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        dateLabel.font = Theme.Font.subhead()
        dateLabel.textColor = Theme.Colors.textSecondary
        dateLabel.text = getCurrentDate()
        headerView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(4)
            make.leading.bottom.equalToSuperview()
        }
    }

    private func setupMoodCard() {
        moodCard.backgroundColor = Theme.Colors.backgroundCard
        moodCard.layer.cornerRadius = Theme.CornerRadius.xl
        Theme.Shadow.apply(to: moodCard, opacity: 0.2, radius: 24)
        contentView.addSubview(moodCard)
        moodCard.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }

        // Title
        let moodTitleLabel = UILabel()
        moodTitleLabel.text = "Your Mood"
        moodTitleLabel.font = Theme.Font.headline()
        moodTitleLabel.textColor = Theme.Colors.textPrimary
        moodCard.addSubview(moodTitleLabel)
        moodTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        // Mood Ring
        moodRingContainer.backgroundColor = Theme.Colors.backgroundElevated
        moodRingContainer.layer.cornerRadius = 60
        moodCard.addSubview(moodRingContainer)
        moodRingContainer.snp.makeConstraints { make in
            make.top.equalTo(moodTitleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
            make.size.equalTo(120)
        }

        // Ring placeholder (actual ring view in component)
        let ringPlaceholder = UIView()
        ringPlaceholder.backgroundColor = Theme.Colors.primary.withAlphaComponent(0.2)
        ringPlaceholder.layer.cornerRadius = 50
        moodRingContainer.addSubview(ringPlaceholder)
        ringPlaceholder.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }

        moodEmojiLabel.font = .systemFont(ofSize: 48)
        moodEmojiLabel.textAlignment = .center
        moodEmojiLabel.text = "😊"
        ringPlaceholder.addSubview(moodEmojiLabel)
        moodEmojiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // Score
        moodScoreLabel.font = Theme.Font.title1()
        moodScoreLabel.textColor = Theme.Colors.primary
        moodScoreLabel.text = "75"
        moodCard.addSubview(moodScoreLabel)
        moodScoreLabel.snp.makeConstraints { make in
            make.top.equalTo(moodTitleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.equalTo(moodRingContainer.snp.trailing).offset(Theme.Spacing.lg)
        }

        // Label
        let scoreLabel = UILabel()
        scoreLabel.text = "Mood Score"
        scoreLabel.font = Theme.Font.caption()
        scoreLabel.textColor = Theme.Colors.textMuted
        moodCard.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(moodScoreLabel.snp.bottom).offset(2)
            make.leading.equalTo(moodScoreLabel)
        }

        // Subtitle
        moodSubtitleLabel.font = Theme.Font.subhead()
        moodSubtitleLabel.textColor = Theme.Colors.textSecondary
        moodSubtitleLabel.numberOfLines = 2
        moodSubtitleLabel.text = "Track your emotional journey"
        moodCard.addSubview(moodSubtitleLabel)
        moodSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.equalTo(moodScoreLabel)
            make.trailing.equalToSuperview().offset(-Theme.Spacing.lg)
        }

        // Bottom padding
        let bottomSpacer = UIView()
        moodCard.addSubview(bottomSpacer)
        bottomSpacer.snp.makeConstraints { make in
            make.top.equalTo(moodRingContainer.snp.bottom).offset(Theme.Spacing.lg)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.lg)
        }
    }

    private func setupStatsRow() {
        statsStack.axis = .horizontal
        statsStack.spacing = Theme.Spacing.md
        statsStack.distribution = .fillEqually
        contentView.addSubview(statsStack)
        statsStack.snp.makeConstraints { make in
            make.top.equalTo(moodCard.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(90)
        }

        // Streak Card
        let streakCard = createStatCard(icon: "flame.fill", iconColor: Theme.Colors.accent, value: "0", label: "Day Streak")
        statsStack.addArrangedSubview(streakCard)

        // XP Card
        let xpCard = createStatCard(icon: "star.fill", iconColor: Theme.Colors.warning, value: "0", label: "Total XP")
        statsStack.addArrangedSubview(xpCard)

        // Level Card
        let levelCard = createStatCard(icon: "chart.line.uptrend.xyaxis", iconColor: Theme.Colors.secondary, value: "1", label: "Level")
        statsStack.addArrangedSubview(levelCard)
    }

    private func createStatCard(icon: String, iconColor: UIColor, value: String, label: String) -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.backgroundCard
        card.layer.cornerRadius = Theme.CornerRadius.large
        Theme.Shadow.apply(to: card, opacity: 0.15, radius: 12)

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = iconColor
        iconView.contentMode = .scaleAspectFit
        card.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.md)
            make.centerX.equalToSuperview()
            make.size.equalTo(24)
        }

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = Theme.Font.title2()
        valueLabel.textColor = Theme.Colors.textPrimary
        valueLabel.textAlignment = .center
        valueLabel.tag = 100
        card.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        let labelView = UILabel()
        labelView.text = label
        labelView.font = Theme.Font.caption()
        labelView.textColor = Theme.Colors.textMuted
        labelView.textAlignment = .center
        card.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Theme.Spacing.md)
        }

        return card
    }

    private func setupQuickActions() {
        quickActionsLabel.text = "Quick Actions"
        quickActionsLabel.font = Theme.Font.title3()
        quickActionsLabel.textColor = Theme.Colors.textPrimary
        contentView.addSubview(quickActionsLabel)
        quickActionsLabel.snp.makeConstraints { make in
            make.top.equalTo(statsStack.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        quickActionsStack.axis = .horizontal
        quickActionsStack.spacing = Theme.Spacing.md
        quickActionsStack.distribution = .fillEqually
        contentView.addSubview(quickActionsStack)
        quickActionsStack.snp.makeConstraints { make in
            make.top.equalTo(quickActionsLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(80)
        }

        let journalBtn = createActionButton(title: "Journal", icon: "book.fill", color: Theme.Colors.primary)
        let practiceBtn = createActionButton(title: "Practice", icon: "person.2.fill", color: Theme.Colors.secondary)
        journalBtn.addTarget(self, action: #selector(openJournal), for: .touchUpInside)
        practiceBtn.addTarget(self, action: #selector(openRolePlay), for: .touchUpInside)
        quickActionsStack.addArrangedSubview(journalBtn)
        quickActionsStack.addArrangedSubview(practiceBtn)
    }

    private func createActionButton(title: String, icon: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = Theme.Colors.backgroundCard
        button.layer.cornerRadius = Theme.CornerRadius.large

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 6
        stack.isUserInteractionEnabled = false
        button.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        iconView.snp.makeConstraints { make in make.size.equalTo(28) }
        stack.addArrangedSubview(iconView)

        let label = UILabel()
        label.text = title
        label.font = Theme.Font.subhead()
        label.textColor = Theme.Colors.textPrimary
        stack.addArrangedSubview(label)

        Theme.Shadow.apply(to: button, opacity: 0.1, radius: 10)
        return button
    }

    private func setupWeeklyCard() {
        weeklyCard.backgroundColor = Theme.Colors.backgroundCard
        weeklyCard.layer.cornerRadius = Theme.CornerRadius.xl
        Theme.Shadow.apply(to: weeklyCard, opacity: 0.15, radius: 16)
        contentView.addSubview(weeklyCard)
        weeklyCard.snp.makeConstraints { make in
            make.top.equalTo(quickActionsStack.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.lg)
        }

        weeklyTitleLabel.text = "This Week"
        weeklyTitleLabel.font = Theme.Font.headline()
        weeklyTitleLabel.textColor = Theme.Colors.textPrimary
        weeklyCard.addSubview(weeklyTitleLabel)
        weeklyTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        weeklyBarsContainer.backgroundColor = Theme.Colors.backgroundElevated
        weeklyBarsContainer.layer.cornerRadius = Theme.CornerRadius.medium
        weeklyCard.addSubview(weeklyBarsContainer)
        weeklyBarsContainer.snp.makeConstraints { make in
            make.top.equalTo(weeklyTitleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(120)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.lg)
        }

        setupWeeklyBars()
    }

    private func setupWeeklyBars() {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        let barWidth: CGFloat = 24
        let spacing: CGFloat = 16

        for (index, day) in days.enumerated() {
            let barContainer = UIView()
            weeklyBarsContainer.addSubview(barContainer)
            barContainer.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(CGFloat(index) * (barWidth + spacing) + 12)
                make.bottom.equalToSuperview().offset(-8)
                make.width.equalTo(barWidth)
            }

            let bar = UIView()
            bar.backgroundColor = barColor(for: index)
            bar.layer.cornerRadius = 4
            barContainer.addSubview(bar)
            bar.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(CGFloat.random(in: 30...100))
            }

            let dayLabel = UILabel()
            dayLabel.text = day
            dayLabel.font = Theme.Font.caption()
            dayLabel.textColor = Theme.Colors.textMuted
            dayLabel.textAlignment = .center
            barContainer.addSubview(dayLabel)
            dayLabel.snp.makeConstraints { make in
                make.bottom.equalTo(bar.snp.top).offset(-6)
                make.centerX.equalToSuperview()
            }
        }
    }

    private func barColor(for index: Int) -> UIColor {
        let colors: [UIColor] = [Theme.Colors.primary, Theme.Colors.secondary, Theme.Colors.accent,
                                  Theme.Colors.warning, Theme.Colors.error, Theme.Colors.primary, Theme.Colors.secondary]
        return colors[index % colors.count].withAlphaComponent(0.7)
    }

    private func bindData() {
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }

    private func updateUI() {
        moodEmojiLabel.text = viewModel.currentMoodEmoji
        moodScoreLabel.text = "\(viewModel.currentMoodScore)"
        moodSubtitleLabel.text = viewModel.todayInsight ?? "Start journaling to see insights"

        if let streakView = statsStack.arrangedSubviews.first?.viewWithTag(100) as? UILabel {
            streakView.text = "\(viewModel.streakDays)"
        }
    }

    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good Morning" }
        if hour < 17 { return "Good Afternoon" }
        return "Good Evening"
    }

    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }

    @objc private func openJournal() {
        tabBarController?.selectedIndex = 1
    }

    @objc private func openRolePlay() {
        tabBarController?.selectedIndex = 2
    }
}
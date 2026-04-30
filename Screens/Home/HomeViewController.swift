import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private let viewModel = HomeViewModel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let moodRingView = MoodRingView()
    private let welcomeLabel = UILabel()
    private let todayInsightLabel = UILabel()
    private let quickActionsStack = UIStackView()
    private let streakBadge = StreakBadge()
    private let weeklyChartContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.refreshData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.backgroundDark

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }

        setupMoodRing()
        setupWelcomeSection()
        setupQuickActions()
        setupStreakSection()
        setupWeeklyChart()
    }

    private func setupMoodRing() {
        contentView.addSubview(moodRingView)
        moodRingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.lg)
            make.centerX.equalToSuperview()
            make.size.equalTo(200)
        }
        moodRingView.animateIn()
    }

    private func setupWelcomeSection() {
        welcomeLabel.font = Theme.Font.heading2()
        welcomeLabel.textColor = Theme.Colors.textPrimaryDark
        welcomeLabel.textAlignment = .center
        welcomeLabel.text = "How are you feeling?"
        contentView.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(moodRingView.snp.bottom).offset(Theme.Spacing.md)
            make.centerX.equalToSuperview()
        }

        todayInsightLabel.font = Theme.Font.caption()
        todayInsightLabel.textColor = Theme.Colors.textSecondaryDark
        todayInsightLabel.textAlignment = .center
        todayInsightLabel.numberOfLines = 2
        contentView.addSubview(todayInsightLabel)
        todayInsightLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }
    }

    private func setupQuickActions() {
        quickActionsStack.axis = .horizontal
        quickActionsStack.spacing = Theme.Spacing.md
        quickActionsStack.distribution = .fillEqually
        contentView.addSubview(quickActionsStack)
        quickActionsStack.snp.makeConstraints { make in
            make.top.equalTo(todayInsightLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(80)
        }

        let journalButton = createQuickActionButton(title: "Quick Journal", icon: "book.fill", color: Theme.Colors.primary)
        journalButton.addTarget(self, action: #selector(openJournal), for: .touchUpInside)
        quickActionsStack.addArrangedSubview(journalButton)

        let practiceButton = createQuickActionButton(title: "Practice", icon: "person.2.fill", color: Theme.Colors.secondary)
        practiceButton.addTarget(self, action: #selector(openRolePlay), for: .touchUpInside)
        quickActionsStack.addArrangedSubview(practiceButton)
    }

    private func createQuickActionButton(title: String, icon: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = Theme.Colors.surfaceDark
        button.layer.cornerRadius = Theme.CornerRadius.medium

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
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
        label.font = Theme.Font.caption()
        label.textColor = Theme.Colors.textPrimaryDark
        stack.addArrangedSubview(label)

        return button
    }

    private func setupStreakSection() {
        contentView.addSubview(streakBadge)
        streakBadge.snp.makeConstraints { make in
            make.top.equalTo(quickActionsStack.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(64)
        }
    }

    private func setupWeeklyChart() {
        let chartTitle = UILabel()
        chartTitle.text = "This Week's Mood"
        chartTitle.font = Theme.Font.heading3()
        chartTitle.textColor = Theme.Colors.textPrimaryDark
        contentView.addSubview(chartTitle)
        chartTitle.snp.makeConstraints { make in
            make.top.equalTo(streakBadge.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        weeklyChartContainer.backgroundColor = Theme.Colors.surfaceDark
        weeklyChartContainer.layer.cornerRadius = Theme.CornerRadius.large
        contentView.addSubview(weeklyChartContainer)
        weeklyChartContainer.snp.makeConstraints { make in
            make.top.equalTo(chartTitle.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(180)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.lg)
        }
    }

    private func bindData() {
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }

    private func updateUI() {
        moodRingView.moodScore = viewModel.currentMoodScore
        moodRingView.moodEmoji = viewModel.currentMoodEmoji
        moodRingView.moodTitle = viewModel.currentMoodTitle
        streakBadge.streakDays = viewModel.streakDays

        if let insight = viewModel.todayInsight {
            todayInsightLabel.text = insight
        } else {
            todayInsightLabel.text = "Complete your first journal entry to see insights!"
        }

        setupChartBars()
    }

    private func setupChartBars() {
        weeklyChartContainer.subviews.forEach { $0.removeFromSuperview() }

        let data = viewModel.weeklyMoodData
        let barWidth: CGFloat = 32
        let spacing: CGFloat = 20
        let startX: CGFloat = 30

        let days = ["M", "T", "W", "T", "F", "S", "S"]

        for (index, value) in data.enumerated() {
            let barView = UIView()
            barView.backgroundColor = barColor(for: Int(value))
            barView.layer.cornerRadius = 6
            weeklyChartContainer.addSubview(barView)

            let xPos = startX + CGFloat(index) * (barWidth + spacing)
            let maxHeight: CGFloat = 120
            let barHeight = CGFloat(value) / 100.0 * maxHeight

            barView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-30)
                make.leading.equalToSuperview().offset(xPos)
                make.width.equalTo(barWidth)
                make.height.equalTo(barHeight)
            }

            let dayLabel = UILabel()
            dayLabel.text = days[index]
            dayLabel.font = Theme.Font.caption()
            dayLabel.textColor = Theme.Colors.textSecondaryDark
            dayLabel.textAlignment = .center
            weeklyChartContainer.addSubview(dayLabel)
            dayLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-8)
                make.centerX.equalTo(barView)
            }
        }
    }

    private func barColor(for value: Int) -> UIColor {
        if value >= 80 { return Theme.Colors.success }
        if value >= 60 { return Theme.Colors.secondary }
        if value >= 40 { return Theme.Colors.warning }
        return Theme.Colors.error
    }

    @objc private func openJournal() {
        tabBarController?.selectedIndex = 1
    }

    @objc private func openRolePlay() {
        tabBarController?.selectedIndex = 2
    }
}
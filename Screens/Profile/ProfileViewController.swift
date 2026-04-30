import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    private let viewModel = ProfileViewModel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let levelBadge = UIView()
    private let levelLabel = UILabel()

    private let statsContainer = UIView()
    private let premiumButton = UIButton(type: .system)
    private let settingsTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        viewModel.loadProfile()
    }

    private func setupUI() {
        title = "Profile"
        view.backgroundColor = Theme.Colors.backgroundDark
        navigationController?.navigationBar.prefersLargeTitles = true

        setupScrollView()
        setupAvatar()
        setupStats()
        setupPremiumButton()
        setupSettings()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
    }

    private func setupAvatar() {
        // Avatar Circle with Gradient Border
        avatarView.backgroundColor = Theme.Colors.backgroundCard
        avatarView.layer.cornerRadius = 50
        avatarView.layer.borderWidth = 3
        avatarView.layer.borderColor = Theme.Colors.primary.cgColor
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.xl)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }

        avatarLabel.text = "SS"
        avatarLabel.font = Theme.Font.largeTitle()
        avatarLabel.textColor = Theme.Colors.textPrimary
        avatarLabel.textAlignment = .center
        avatarView.addSubview(avatarLabel)
        avatarLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // Name
        nameLabel.text = "EQBoostAI User"
        nameLabel.font = Theme.Font.title2()
        nameLabel.textColor = Theme.Colors.textPrimary
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(Theme.Spacing.md)
            make.centerX.equalToSuperview()
        }

        // Level Badge
        levelBadge.backgroundColor = Theme.Colors.primary.withAlphaComponent(0.2)
        levelBadge.layer.cornerRadius = Theme.CornerRadius.full
        contentView.addSubview(levelBadge)
        levelBadge.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }

        levelLabel.text = "Level 1 • 0 XP"
        levelLabel.font = Theme.Font.subhead()
        levelLabel.textColor = Theme.Colors.primary
        levelBadge.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }
    }

    private func setupStats() {
        statsContainer.backgroundColor = Theme.Colors.backgroundCard
        statsContainer.layer.cornerRadius = Theme.CornerRadius.xl
        Theme.Shadow.apply(to: statsContainer, opacity: 0.15, radius: 16)
        contentView.addSubview(statsContainer)
        statsContainer.snp.makeConstraints { make in
            make.top.equalTo(levelBadge.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }

        let statsStack = UIStackView()
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsContainer.addSubview(statsStack)
        statsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Theme.Spacing.lg)
        }

        let streakView = createStatView(icon: "flame.fill", iconColor: Theme.Colors.accent, value: "0", label: "Streak")
        streakView.tag = 100
        let journalView = createStatView(icon: "book.fill", iconColor: Theme.Colors.secondary, value: "0", label: "Journals")
        journalView.tag = 101
        let scoreView = createStatView(icon: "brain.head.profile", iconColor: Theme.Colors.primary, value: "50", label: "Social IQ")
        scoreView.tag = 102

        statsStack.addArrangedSubview(streakView)
        statsStack.addArrangedSubview(journalView)
        statsStack.addArrangedSubview(scoreView)
    }

    private func createStatView(icon: String, iconColor: UIColor, value: String, label: String) -> UIView {
        let container = UIView()

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = iconColor
        iconView.contentMode = .scaleAspectFit
        container.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(28)
        }

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = Theme.Font.title2()
        valueLabel.textColor = Theme.Colors.textPrimary
        valueLabel.textAlignment = .center
        valueLabel.tag = 1
        container.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        let labelView = UILabel()
        labelView.text = label
        labelView.font = Theme.Font.caption()
        labelView.textColor = Theme.Colors.textMuted
        labelView.textAlignment = .center
        container.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        return container
    }

    private func setupPremiumButton() {
        premiumButton.setTitle("Upgrade to Premium", for: .normal)
        premiumButton.titleLabel?.font = Theme.Font.headline()
        premiumButton.backgroundColor = Theme.Colors.primary
        premiumButton.setTitleColor(.white, for: .normal)
        premiumButton.layer.cornerRadius = Theme.CornerRadius.large
        premiumButton.addTarget(self, action: #selector(openPremium), for: .touchUpInside)

        // Add gradient effect
        premiumButton.layer.borderWidth = 2
        premiumButton.layer.borderColor = Theme.Colors.primaryLight.cgColor

        contentView.addSubview(premiumButton)
        premiumButton.snp.makeConstraints { make in
            make.top.equalTo(statsContainer.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(56)
        }
    }

    private func setupSettings() {
        let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        settingsLabel.font = Theme.Font.title3()
        settingsLabel.textColor = Theme.Colors.textPrimary
        contentView.addSubview(settingsLabel)
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(premiumButton.snp.bottom).offset(Theme.Spacing.xl)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        settingsTableView.backgroundColor = .clear
        settingsTableView.separatorStyle = .none
        settingsTableView.isScrollEnabled = false
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        contentView.addSubview(settingsTableView)
        settingsTableView.snp.makeConstraints { make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(300)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.xl)
        }
    }

    private func bindData() {
        viewModel.onProfileUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }

    private func updateUI() {
        levelLabel.text = "Level \(viewModel.level) • \(viewModel.totalXP) XP"

        if let streakView = statsContainer.viewWithTag(100),
           let valueLabel = streakView.viewWithTag(1) as? UILabel {
            valueLabel.text = "\(viewModel.streakDays)"
        }
        if let journalView = statsContainer.viewWithTag(101),
           let valueLabel = journalView.viewWithTag(1) as? UILabel {
            valueLabel.text = "\(viewModel.journalCount)"
        }
        if let scoreView = statsContainer.viewWithTag(102),
           let valueLabel = scoreView.viewWithTag(1) as? UILabel {
            valueLabel.text = "\(viewModel.socialIQScore)"
        }
    }

    @objc private func openPremium() {
        let alert = UIAlertController(title: "🔮 EQBoostAI Premium", message: "Unlock unlimited roleplay scenarios, advanced AI insights, and personalized coaching!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Subscribe - $2.99/mo", style: .default))
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel))
        present(alert, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SettingCell")
        cell.backgroundColor = Theme.Colors.backgroundCard
        cell.textLabel?.text = viewModel.settingsOptions[indexPath.row]
        cell.textLabel?.textColor = Theme.Colors.textPrimary
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none

        let selectedBg = UIView()
        selectedBg.backgroundColor = Theme.Colors.backgroundElevated
        cell.selectedBackgroundView = selectedBg

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
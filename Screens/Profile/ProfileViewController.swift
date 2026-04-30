import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    private let viewModel = ProfileViewModel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
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

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }

        setupAvatar()
        setupStats()
        setupPremiumButton()
        setupSettings()
    }

    private func setupAvatar() {
        avatarView.backgroundColor = Theme.Colors.primary
        avatarView.layer.cornerRadius = 50
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.xl)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }

        avatarLabel.text = "SS"
        avatarLabel.font = Theme.Font.heading1()
        avatarLabel.textColor = .white
        avatarLabel.textAlignment = .center
        avatarView.addSubview(avatarLabel)
        avatarLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        nameLabel.text = "SoulSync User"
        nameLabel.font = Theme.Font.heading2()
        nameLabel.textColor = Theme.Colors.textPrimaryDark
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(Theme.Spacing.md)
            make.centerX.equalToSuperview()
        }

        levelLabel.text = "Level 1 • 0 XP"
        levelLabel.font = Theme.Font.body()
        levelLabel.textColor = Theme.Colors.textSecondaryDark
        levelLabel.textAlignment = .center
        contentView.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Theme.Spacing.xs)
            make.centerX.equalToSuperview()
        }
    }

    private func setupStats() {
        statsContainer.backgroundColor = Theme.Colors.surfaceDark
        statsContainer.layer.cornerRadius = Theme.CornerRadius.large
        contentView.addSubview(statsContainer)
        statsContainer.snp.makeConstraints { make in
            make.top.equalTo(levelLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(100)
        }

        let statsStack = UIStackView()
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsContainer.addSubview(statsStack)
        statsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        let streakView = createStatItem(value: "0", label: "Streak", icon: "flame.fill", color: Theme.Colors.warning)
        let journalView = createStatItem(value: "0", label: "Journals", icon: "book.fill", color: Theme.Colors.secondary)
        let scoreView = createStatItem(value: "50", label: "Social IQ", icon: "brain.head.profile", color: Theme.Colors.primary)

        streakView.tag = 100
        journalView.tag = 101
        scoreView.tag = 102

        statsStack.addArrangedSubview(streakView)
        statsStack.addArrangedSubview(journalView)
        statsStack.addArrangedSubview(scoreView)
    }

    private func createStatItem(value: String, label: String, icon: String, color: UIColor) -> UIView {
        let container = UIView()

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        container.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(24)
        }

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = Theme.Font.heading2()
        valueLabel.textColor = Theme.Colors.textPrimaryDark
        valueLabel.textAlignment = .center
        valueLabel.tag = 1
        container.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        let labelView = UILabel()
        labelView.text = label
        labelView.font = Theme.Font.caption()
        labelView.textColor = Theme.Colors.textSecondaryDark
        labelView.textAlignment = .center
        container.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }

        return container
    }

    private func setupPremiumButton() {
        premiumButton.setTitle("Upgrade to Premium", for: .normal)
        premiumButton.titleLabel?.font = Theme.Font.button()
        premiumButton.backgroundColor = Theme.Colors.primary
        premiumButton.setTitleColor(.white, for: .normal)
        premiumButton.layer.cornerRadius = Theme.CornerRadius.medium
        premiumButton.addTarget(self, action: #selector(openPremium), for: .touchUpInside)
        contentView.addSubview(premiumButton)
        premiumButton.snp.makeConstraints { make in
            make.top.equalTo(statsContainer.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(56)
        }
    }

    private func setupSettings() {
        let settingsTitle = UILabel()
        settingsTitle.text = "Settings"
        settingsTitle.font = Theme.Font.heading3()
        settingsTitle.textColor = Theme.Colors.textPrimaryDark
        contentView.addSubview(settingsTitle)
        settingsTitle.snp.makeConstraints { make in
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
            make.top.equalTo(settingsTitle.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(250)
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
        let alert = UIAlertController(title: "SoulSync Premium", message: "Unlock unlimited roleplay scenarios, advanced AI insights, and more!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Subscribe - $2.99/mo", style: .default) { _ in
        })
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel))
        present(alert, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.backgroundColor = Theme.Colors.surfaceDark
        cell.textLabel?.text = viewModel.settingsOptions[indexPath.row]
        cell.textLabel?.textColor = Theme.Colors.textPrimaryDark
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
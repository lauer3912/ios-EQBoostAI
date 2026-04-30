import UIKit
import SnapKit

class RolePlayViewController: UIViewController {

    private let viewModel = RolePlayViewModel()

    private let headerLabel = UILabel()
    private let filterSegment = UISegmentedControl(items: ["All", "Free", "Premium"])
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let scenariosStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        viewModel.loadScenarios()
    }

    private func setupUI() {
        title = "Practice"
        view.backgroundColor = Theme.Colors.backgroundDark
        navigationController?.navigationBar.prefersLargeTitles = true

        // Header
        headerLabel.text = "Roleplay Scenarios"
        headerLabel.font = Theme.Font.largeTitle()
        headerLabel.textColor = Theme.Colors.textPrimary
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        // Filter
        filterSegment.selectedSegmentIndex = 0
        filterSegment.backgroundColor = Theme.Colors.backgroundCard
        filterSegment.selectedSegmentTintColor = Theme.Colors.primary
        filterSegment.setTitleTextAttributes([.foregroundColor: Theme.Colors.textSecondary], for: .normal)
        filterSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        filterSegment.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        view.addSubview(filterSegment)
        filterSegment.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }

        // Scroll View
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(filterSegment.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }

        scenariosStackView.axis = .vertical
        scenariosStackView.spacing = Theme.Spacing.md
        contentView.addSubview(scenariosStackView)
        scenariosStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Theme.Spacing.lg)
        }
    }

    private func bindData() {
        viewModel.onScenariosUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateScenarios()
            }
        }
    }

    private func updateScenarios() {
        scenariosStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for scenario in viewModel.filteredScenarios {
            let card = createScenarioCard(scenario)
            scenariosStackView.addArrangedSubview(card)
        }
    }

    private func createScenarioCard(_ scenario: Scenario) -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.backgroundCard
        card.layer.cornerRadius = Theme.CornerRadius.large
        Theme.Shadow.apply(to: card, opacity: 0.15, radius: 12)

        // Icon
        let iconView = UIImageView(image: UIImage(systemName: scenario.iconName))
        iconView.tintColor = Theme.Colors.primary
        iconView.contentMode = .scaleAspectFit
        card.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
            make.centerY.equalToSuperview()
            make.size.equalTo(44)
        }

        // Content
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 4
        card.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(Theme.Spacing.md)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Theme.Spacing.lg)
        }

        let titleLabel = UILabel()
        titleLabel.text = scenario.title
        titleLabel.font = Theme.Font.headline()
        titleLabel.textColor = Theme.Colors.textPrimary
        contentStack.addArrangedSubview(titleLabel)

        let descLabel = UILabel()
        descLabel.text = scenario.description
        descLabel.font = Theme.Font.footnote()
        descLabel.textColor = Theme.Colors.textMuted
        descLabel.numberOfLines = 2
        contentStack.addArrangedSubview(descLabel)

        // Tags
        let tagsStack = UIStackView()
        tagsStack.axis = .horizontal
        tagsStack.spacing = 6
        contentStack.addArrangedSubview(tagsStack)

        let categoryTag = createTag(scenario.category.rawValue, color: Theme.Colors.primary)
        let diffTag = createTag(scenario.difficulty.rawValue, color: UIColor(hex: scenario.difficulty.color))
        tagsStack.addArrangedSubview(categoryTag)
        tagsStack.addArrangedSubview(diffTag)

        // Premium Lock
        if scenario.isPremium {
            let lockIcon = UIImageView(image: UIImage(systemName: "lock.fill"))
            lockIcon.tintColor = Theme.Colors.warning
            lockIcon.contentMode = .scaleAspectFit
            card.addSubview(lockIcon)
            lockIcon.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-Theme.Spacing.lg)
                make.top.equalToSuperview().offset(Theme.Spacing.lg)
                make.size.equalTo(16)
            }
        }

        // Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(scenarioTapped(_:)))
        card.addGestureRecognizer(tap)
        card.isUserInteractionEnabled = true
        card.accessibilityIdentifier = scenario.id

        card.snp.makeConstraints { make in
            make.height.equalTo(120)
        }

        return card
    }

    private func createTag(_ text: String, color: UIColor) -> UIView {
        let tag = UILabel()
        tag.text = text
        tag.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        tag.textColor = color
        tag.backgroundColor = color.withAlphaComponent(0.15)
        tag.layer.cornerRadius = 6
        tag.clipsToBounds = true
        tag.textAlignment = .center
        tag.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.greaterThanOrEqualTo(60)
        }
        return tag
    }

    @objc private func scenarioTapped(_ gesture: UITapGestureRecognizer) {
        guard let card = gesture.view, let scenarioId = card.accessibilityIdentifier else { return }
        if let scenario = viewModel.filteredScenarios.first(where: { $0.id == scenarioId }) {
            let detailVC = ScenarioDetailViewController()
            detailVC.scenario = scenario
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    @objc private func filterChanged() {
        let filter: ScenarioFilter
        switch filterSegment.selectedSegmentIndex {
        case 1: filter = .free
        case 2: filter = .premium
        default: filter = .all
        }
        viewModel.applyFilter(filter)
    }
}
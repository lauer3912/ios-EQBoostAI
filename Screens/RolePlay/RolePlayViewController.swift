import UIKit
import SnapKit

class RolePlayViewController: UIViewController {

    private let viewModel = RolePlayViewModel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let categorySegment = UISegmentedControl()
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

        view.addSubview(categorySegment)
        categorySegment.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }

        let categories = ["All", "Free", "Premium"]
        for (index, cat) in categories.enumerated() {
            categorySegment.insertSegment(withTitle: cat, at: index, enabled: true)
        }
        categorySegment.selectedSegmentIndex = 0
        categorySegment.addTarget(self, action: #selector(filterChanged), for: .valueChanged)

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(categorySegment.snp.bottom).offset(Theme.Spacing.lg)
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
            let card = ScenarioCard()
            card.scenario = scenario
            card.onTap = { [weak self] in
                self?.openScenario(scenario)
            }
            card.snp.makeConstraints { make in
                make.height.equalTo(140)
            }
            scenariosStackView.addArrangedSubview(card)
        }
    }

    @objc private func filterChanged() {
        let filter: ScenarioService.ScenarioFilter
        switch categorySegment.selectedSegmentIndex {
        case 1: filter = .free
        case 2: filter = .premium
        default: filter = .all
        }
        viewModel.applyFilter(filter)
    }

    private func openScenario(_ scenario: Scenario) {
        let detailVC = ScenarioDetailViewController()
        detailVC.scenario = scenario
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// RolePlayViewModel is in RolePlayViewModel.swift

extension RolePlayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredScenarios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
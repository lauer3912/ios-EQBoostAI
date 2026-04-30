import UIKit
import SnapKit

class TasksViewController: UIViewController {

    private let viewModel = TasksViewModel()

    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let xpLabel = UILabel()
    private let tableView = UITableView()
    private let emptyStateView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        viewModel.loadTasks()
    }

    private func setupUI() {
        title = "Tasks"
        view.backgroundColor = Theme.Colors.backgroundDark
        navigationController?.navigationBar.prefersLargeTitles = true

        setupHeader()
        setupTableView()
        setupEmptyState()
    }

    private func setupHeader() {
        headerView.backgroundColor = Theme.Colors.backgroundCard
        headerView.layer.cornerRadius = Theme.CornerRadius.xl
        Theme.Shadow.apply(to: headerView, opacity: 0.15, radius: 16)
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }

        let iconView = UIImageView(image: UIImage(systemName: "star.fill"))
        iconView.tintColor = Theme.Colors.warning
        iconView.contentMode = .scaleAspectFit
        headerView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }

        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 4
        headerView.addSubview(textStack)
        textStack.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(Theme.Spacing.md)
            make.centerY.equalToSuperview()
        }

        titleLabel.text = "Today's Missions"
        titleLabel.font = Theme.Font.title2()
        titleLabel.textColor = Theme.Colors.textPrimary
        textStack.addArrangedSubview(titleLabel)

        xpLabel.text = "0 XP earned"
        xpLabel.font = Theme.Font.subhead()
        xpLabel.textColor = Theme.Colors.warning
        textStack.addArrangedSubview(xpLabel)

        // Streak badge
        let streakBadge = UIView()
        streakBadge.backgroundColor = Theme.Colors.accent.withAlphaComponent(0.2)
        streakBadge.layer.cornerRadius = Theme.CornerRadius.medium
        headerView.addSubview(streakBadge)
        streakBadge.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Theme.Spacing.lg)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(44)
        }

        let flameIcon = UIImageView(image: UIImage(systemName: "flame.fill"))
        flameIcon.tintColor = Theme.Colors.accent
        streakBadge.addSubview(flameIcon)
        flameIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }

        let streakLabel = UILabel()
        streakLabel.text = "\(viewModel.streakDays)"
        streakLabel.font = Theme.Font.headline()
        streakLabel.textColor = Theme.Colors.accent
        streakBadge.addSubview(streakLabel)
        streakLabel.snp.makeConstraints { make in
            make.leading.equalTo(flameIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupEmptyState() {
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let iconView = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        iconView.tintColor = Theme.Colors.success
        iconView.contentMode = .scaleAspectFit
        emptyStateView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(60)
        }

        let label = UILabel()
        label.text = "All tasks completed!"
        label.font = Theme.Font.title3()
        label.textColor = Theme.Colors.textPrimary
        emptyStateView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(Theme.Spacing.md)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func bindData() {
        viewModel.onTasksUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.xpLabel.text = "\(self?.viewModel.earnedXP ?? 0) XP earned"
                self?.emptyStateView.isHidden = !(self?.viewModel.tasks.isEmpty ?? true)
            }
        }
    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.task = viewModel.tasks[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.tasks[indexPath.row]
        if !task.isCompleted {
            viewModel.completeTask(at: indexPath.row)
        }
    }
}
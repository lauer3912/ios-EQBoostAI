import UIKit
import SnapKit

class TasksViewController: UIViewController {

    private let viewModel = TasksViewModel()

    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let xpLabel = UILabel()
    private let tableView = UITableView()
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        viewModel.loadTasks()
    }

    private func setupUI() {
        title = "Daily Tasks"
        view.backgroundColor = Theme.Colors.backgroundDark

        setupHeader()
        setupTableView()
    }

    private func setupHeader() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(80)
        }

        let iconView = UIImageView(image: UIImage(systemName: "star.fill"))
        iconView.tintColor = Theme.Colors.warning
        iconView.contentMode = .scaleAspectFit
        headerView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }

        titleLabel.text = "Today's Missions"
        titleLabel.font = Theme.Font.heading2()
        titleLabel.textColor = Theme.Colors.textPrimaryDark
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.top.equalTo(iconView)
        }

        xpLabel.text = "0 XP earned"
        xpLabel.font = Theme.Font.body()
        xpLabel.textColor = Theme.Colors.warning
        headerView.addSubview(xpLabel)
        xpLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }

        let streakView = StreakBadge()
        streakView.streakDays = viewModel.streakDays
        headerView.addSubview(streakView)
        streakView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(50)
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
            make.top.equalTo(headerView.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.bottom.equalToSuperview()
        }

        emptyLabel.text = "No tasks available today.\nCheck back tomorrow!"
        emptyLabel.font = Theme.Font.body()
        emptyLabel.textColor = Theme.Colors.textSecondaryDark
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bindData() {
        viewModel.onTasksUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.xpLabel.text = "\(self?.viewModel.earnedXP ?? 0) XP earned"
                self?.emptyLabel.isHidden = !(self?.viewModel.tasks.isEmpty ?? true)
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
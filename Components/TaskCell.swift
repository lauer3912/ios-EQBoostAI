import UIKit
import SnapKit

class TaskCell: UITableViewCell {

    static let identifier = "TaskCell"

    var task: ETask? {
        didSet {
            guard let task = task else { return }
            titleLabel.text = task.title
            descriptionLabel.text = task.description
            xpLabel.text = "+\(task.xpReward) XP"
            categoryIcon.image = UIImage(systemName: task.category.icon)
            categoryIcon.tintColor = UIColor(hex: task.category.color)
            checkboxImageView.image = UIImage(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            checkboxImageView.tintColor = task.isCompleted ? Theme.Colors.success : Theme.Colors.textSecondary
        }
    }

    private let containerView = UIView()
    private let checkboxImageView = UIImageView()
    private let categoryIcon = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let xpLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.backgroundColor = Theme.Colors.backgroundCard
        containerView.layer.cornerRadius = Theme.CornerRadius.medium
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }

        checkboxImageView.contentMode = .scaleAspectFit
        containerView.addSubview(checkboxImageView)
        checkboxImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }

        categoryIcon.contentMode = .scaleAspectFit
        containerView.addSubview(categoryIcon)
        categoryIcon.snp.makeConstraints { make in
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }

        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 2
        containerView.addSubview(textStack)
        textStack.snp.makeConstraints { make in
            make.leading.equalTo(categoryIcon.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(xpLabel.snp.leading).offset(-10)
        }

        titleLabel.font = Theme.Font.body()
        titleLabel.textColor = Theme.Colors.textPrimary
        textStack.addArrangedSubview(titleLabel)

        descriptionLabel.font = Theme.Font.caption()
        descriptionLabel.textColor = Theme.Colors.textSecondary
        descriptionLabel.numberOfLines = 1
        textStack.addArrangedSubview(descriptionLabel)

        xpLabel.font = Theme.Font.caption()
        xpLabel.textColor = Theme.Colors.warning
        xpLabel.textAlignment = .right
        containerView.addSubview(xpLabel)
        xpLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(60)
        }
    }
}
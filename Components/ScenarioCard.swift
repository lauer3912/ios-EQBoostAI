import UIKit
import SnapKit

class ScenarioCard: UIView {

    var scenario: Scenario? {
        didSet {
            guard let scenario = scenario else { return }
            titleLabel.text = scenario.title
            descriptionLabel.text = scenario.description
            categoryLabel.text = scenario.category.rawValue
            difficultyLabel.text = scenario.difficulty.rawValue
            difficultyLabel.textColor = UIColor(hex: scenario.difficulty.color)
            durationLabel.text = "\(scenario.duration) min"
            iconView.image = UIImage(systemName: scenario.iconName)
            lockIcon.isHidden = !scenario.isPremium
        }
    }

    private let containerView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let categoryLabel = UILabel()
    private let difficultyLabel = UILabel()
    private let durationLabel = UILabel()
    private let lockIcon = UIImageView()
    private let chevronIcon = UIImageView()

    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = Theme.Colors.backgroundCard
        layer.cornerRadius = Theme.CornerRadius.large

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = Theme.Colors.primary
        containerView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.size.equalTo(40)
        }

        lockIcon.image = UIImage(systemName: "lock.fill")
        lockIcon.tintColor = Theme.Colors.warning
        lockIcon.contentMode = .scaleAspectFit
        containerView.addSubview(lockIcon)
        lockIcon.snp.makeConstraints { make in
            make.trailing.equalTo(chevronIcon.snp.leading).offset(-8)
            make.centerY.equalTo(iconView)
            make.size.equalTo(16)
        }

        chevronIcon.image = UIImage(systemName: "chevron.right")
        chevronIcon.tintColor = Theme.Colors.textSecondary
        chevronIcon.contentMode = .scaleAspectFit
        containerView.addSubview(chevronIcon)
        chevronIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(iconView)
            make.size.equalTo(16)
        }

        titleLabel.font = Theme.Font.title3()
        titleLabel.textColor = Theme.Colors.textPrimary
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.top.equalTo(iconView)
            make.trailing.equalTo(lockIcon.snp.leading).offset(-8)
        }

        descriptionLabel.font = Theme.Font.caption()
        descriptionLabel.textColor = Theme.Colors.textSecondary
        descriptionLabel.numberOfLines = 2
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
        }

        let bottomStack = UIStackView()
        bottomStack.axis = .horizontal
        bottomStack.spacing = 12
        containerView.addSubview(bottomStack)
        bottomStack.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
        }

        let tagStack = UIStackView()
        tagStack.axis = .horizontal
        tagStack.spacing = 6

        let categoryBadge = createBadge(text: categoryLabel, color: Theme.Colors.primary)
        let difficultyBadge = createBadge(text: difficultyLabel, color: UIColor(hex: scenario?.difficulty.color ?? "#34D399"))
        tagStack.addArrangedSubview(categoryBadge)
        tagStack.addArrangedSubview(difficultyBadge)
        bottomStack.addArrangedSubview(tagStack)

        let durationStack = UIStackView()
        durationStack.axis = .horizontal
        durationStack.spacing = 4

        let clockIcon = UIImageView(image: UIImage(systemName: "clock"))
        clockIcon.tintColor = Theme.Colors.textSecondary
        clockIcon.contentMode = .scaleAspectFit
        clockIcon.snp.makeConstraints { make in make.size.equalTo(14) }
        durationStack.addArrangedSubview(clockIcon)

        let durationLabelTmp = UILabel()
        durationLabelTmp.text = "\(scenario?.duration ?? 10) min"
        durationLabelTmp.font = Theme.Font.caption()
        durationLabelTmp.textColor = Theme.Colors.textSecondary
        durationStack.addArrangedSubview(durationLabelTmp)

        bottomStack.addArrangedSubview(durationStack)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    private func createBadge(text: UILabel, color: UIColor) -> UIView {
        let badge = UILabel()
        badge.text = text.text
        badge.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        badge.textColor = color
        badge.backgroundColor = color.withAlphaComponent(0.15)
        badge.layer.cornerRadius = 6
        badge.clipsToBounds = true
        badge.textAlignment = .center
        badge.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.greaterThanOrEqualTo(60)
        }
        return badge
    }

    @objc private func handleTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
            self.onTap?()
        }
    }
}
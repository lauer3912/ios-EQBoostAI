import UIKit
import SnapKit

class StreakBadge: UIView {

    var streakDays: Int = 0 {
        didSet { updateView() }
    }

    private let flameIcon = UIImageView()
    private let countLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = Theme.Colors.surfaceDark
        layer.cornerRadius = Theme.CornerRadius.medium

        flameIcon.image = UIImage(systemName: "flame.fill")
        flameIcon.tintColor = streakDays > 7 ? Theme.Colors.warning : Theme.Colors.error
        flameIcon.contentMode = .scaleAspectFit
        addSubview(flameIcon)
        flameIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }

        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 2
        addSubview(textStack)
        textStack.snp.makeConstraints { make in
            make.leading.equalTo(flameIcon.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }

        countLabel.font = Theme.Font.heading3()
        countLabel.textColor = Theme.Colors.textPrimaryDark
        textStack.addArrangedSubview(countLabel)

        subtitleLabel.text = "day streak"
        subtitleLabel.font = Theme.Font.caption()
        subtitleLabel.textColor = Theme.Colors.textSecondaryDark
        textStack.addArrangedSubview(subtitleLabel)
    }

    private func updateView() {
        countLabel.text = "\(streakDays)"
        flameIcon.tintColor = streakDays > 7 ? Theme.Colors.warning : Theme.Colors.error

        if streakDays > 7 {
            animateGlow()
        }
    }

    private func animateGlow() {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0.3
        animation.toValue = 0.8
        animation.duration = 1.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        layer.shadowColor = Theme.Colors.warning.cgColor
        layer.shadowRadius = 8
        layer.shadowOffset = .zero
        layer.add(animation, forKey: "glow")
    }
}
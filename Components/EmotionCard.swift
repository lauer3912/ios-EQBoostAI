import UIKit
import SnapKit

class EmotionCard: UIView {

    var emotion: Emotion? {
        didSet {
            guard let emotion = emotion else { return }
            emojiLabel.text = emotion.emoji
            nameLabel.text = emotion.rawValue
            iconView.tintColor = UIColor(hex: emotion.color)
        }
    }

    var isSelected: Bool = false {
        didSet { updateSelectionState() }
    }

    private let iconView = UIImageView()
    private let emojiLabel = UILabel()
    private let nameLabel = UILabel()
    private let checkmarkView = UIImageView()

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
        backgroundColor = Theme.Colors.surfaceDark
        layer.cornerRadius = Theme.CornerRadius.medium

        iconView.image = UIImage(systemName: "circle.fill")
        iconView.contentMode = .scaleAspectFit
        addSubview(iconView)

        emojiLabel.font = .systemFont(ofSize: 24)
        addSubview(emojiLabel)

        nameLabel.font = Theme.Font.caption()
        nameLabel.textColor = Theme.Colors.textSecondaryDark
        addSubview(nameLabel)

        checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkView.tintColor = Theme.Colors.primary
        checkmarkView.isHidden = true
        addSubview(checkmarkView)

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }

        emojiLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(emojiLabel.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
        }

        checkmarkView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.size.equalTo(22)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap() {
        onTap?()
    }

    private func updateSelectionState() {
        checkmarkView.isHidden = !isSelected
        layer.borderWidth = isSelected ? 2 : 0
        layer.borderColor = isSelected ? Theme.Colors.primary.cgColor : nil
    }
}
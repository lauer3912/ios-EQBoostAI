import UIKit
import SnapKit

class JournalEntryCell: UITableViewCell {

    static let identifier = "JournalEntryCell"

    var entry: JournalEntry? {
        didSet {
            guard let entry = entry else { return }

            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            dateLabel.text = formatter.string(from: entry.date)

            previewLabel.text = entry.text.prefix(80) + (entry.text.count > 80 ? "..." : "")
            moodScoreLabel.text = "\(entry.moodScore)%"

            let emotionText = entry.emotions.map { $0.emoji + " " + $0.rawValue }.joined(separator: " ")
            emotionLabel.text = emotionText

            if let score = Int(moodScoreLabel.text?.replacingOccurrences(of: "%", with: "") ?? "50") {
                scoreIndicator.backgroundColor = scoreColor(for: score)
            }
        }
    }

    private let containerView = UIView()
    private let dateLabel = UILabel()
    private let previewLabel = UILabel()
    private let emotionLabel = UILabel()
    private let moodScoreLabel = UILabel()
    private let scoreIndicator = UIView()

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
        containerView.backgroundColor = Theme.Colors.surfaceDark
        containerView.layer.cornerRadius = Theme.CornerRadius.medium
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }

        scoreIndicator.layer.cornerRadius = 4
        containerView.addSubview(scoreIndicator)
        scoreIndicator.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(6)
        }

        dateLabel.font = Theme.Font.caption()
        dateLabel.textColor = Theme.Colors.textSecondaryDark
        containerView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(scoreIndicator.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(12)
        }

        moodScoreLabel.font = Theme.Font.caption()
        moodScoreLabel.textColor = Theme.Colors.primary
        moodScoreLabel.textAlignment = .right
        containerView.addSubview(moodScoreLabel)
        moodScoreLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(dateLabel)
        }

        previewLabel.font = Theme.Font.body()
        previewLabel.textColor = Theme.Colors.textPrimaryDark
        previewLabel.numberOfLines = 2
        containerView.addSubview(previewLabel)
        previewLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel)
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
            make.trailing.equalToSuperview().offset(-16)
        }

        emotionLabel.font = Theme.Font.caption()
        emotionLabel.textColor = Theme.Colors.textSecondaryDark
        containerView.addSubview(emotionLabel)
        emotionLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel)
            make.top.equalTo(previewLabel.snp.bottom).offset(6)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }

    private func scoreColor(for score: Int) -> UIColor {
        if score >= 80 { return Theme.Colors.success }
        if score >= 60 { return Theme.Colors.secondary }
        if score >= 40 { return Theme.Colors.warning }
        return Theme.Colors.error
    }
}
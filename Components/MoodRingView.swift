import UIKit
import SnapKit

class MoodRingView: UIView {

    private let ringLayer = CAShapeLayer()
    private let backgroundRingLayer = CAShapeLayer()
    private let emojiLabel = UILabel()
    private let scoreLabel = UILabel()
    private let titleLabel = UILabel()

    var moodScore: Int = 75 {
        didSet { updateRing() }
    }

    var moodEmoji: String = "😊" {
        didSet { emojiLabel.text = moodEmoji }
    }

    var moodTitle: String = "Good" {
        didSet { titleLabel.text = moodTitle }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.addSublayer(backgroundRingLayer)
        layer.addSublayer(ringLayer)

        emojiLabel.text = moodEmoji
        emojiLabel.font = .systemFont(ofSize: 40)
        emojiLabel.textAlignment = .center
        addSubview(emojiLabel)

        scoreLabel.text = "\(moodScore)"
        scoreLabel.font = Theme.Font.title2()
        scoreLabel.textColor = Theme.Colors.textPrimary
        scoreLabel.textAlignment = .center
        addSubview(scoreLabel)

        titleLabel.text = moodTitle
        titleLabel.font = Theme.Font.caption()
        titleLabel.textColor = Theme.Colors.textSecondary
        titleLabel.textAlignment = .center
        addSubview(titleLabel)

        emojiLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }

        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emojiLabel.snp.bottom).offset(4)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scoreLabel.snp.bottom).offset(2)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupRingLayers()
    }

    private func setupRingLayers() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 10
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi

        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        backgroundRingLayer.path = path.cgPath
        backgroundRingLayer.fillColor = UIColor.clear.cgColor
        backgroundRingLayer.strokeColor = Theme.Colors.backgroundCard.cgColor
        backgroundRingLayer.lineWidth = 12
        backgroundRingLayer.lineCap = .round

        ringLayer.path = path.cgPath
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = moodColor().cgColor
        ringLayer.lineWidth = 12
        ringLayer.lineCap = .round
        ringLayer.strokeEnd = CGFloat(moodScore) / 100.0
    }

    private func moodColor() -> UIColor {
        if moodScore >= 80 { return Theme.Colors.success }
        if moodScore >= 60 { return Theme.Colors.secondary }
        if moodScore >= 40 { return Theme.Colors.warning }
        return Theme.Colors.error
    }

    private func updateRing() {
        scoreLabel.text = "\(moodScore)"
        ringLayer.strokeColor = moodColor().cgColor

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = ringLayer.strokeEnd
        animation.toValue = CGFloat(moodScore) / 100.0
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        ringLayer.strokeEnd = CGFloat(moodScore) / 100.0
        ringLayer.add(animation, forKey: "progress")
    }

    func animateIn() {
        transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5) {
            self.transform = .identity
        }
    }
}
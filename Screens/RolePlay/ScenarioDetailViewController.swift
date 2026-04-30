import UIKit
import SnapKit

class ScenarioDetailViewController: UIViewController {

    var scenario: Scenario?

    private let viewModel = RolePlayViewModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = UIView()
    private let chatContainer = UIView()
    private let inputContainer = UIView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .system)

    private var messages: [ConversationMessage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let scenario = scenario {
            loadScenario(scenario)
        }
    }

    private func setupUI() {
        title = scenario?.title ?? "Practice"
        view.backgroundColor = Theme.Colors.backgroundDark

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }

        setupHeader()
        setupChat()
        setupInput()
    }

    private func setupHeader() {
        headerView.backgroundColor = Theme.Colors.surfaceDark
        headerView.layer.cornerRadius = Theme.CornerRadius.large
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(80)
        }

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: scenario?.iconName ?? "bubble.left.and.bubble.right.fill")
        iconView.tintColor = Theme.Colors.primary
        iconView.contentMode = .scaleAspectFit
        headerView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }

        let titleLabel = UILabel()
        titleLabel.text = scenario?.title
        titleLabel.font = Theme.Font.heading3()
        titleLabel.textColor = Theme.Colors.textPrimaryDark
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.top.equalTo(iconView)
        }

        let descLabel = UILabel()
        descLabel.text = scenario?.description
        descLabel.font = Theme.Font.caption()
        descLabel.textColor = Theme.Colors.textSecondaryDark
        descLabel.numberOfLines = 2
        headerView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    private func setupChat() {
        chatContainer.backgroundColor = Theme.Colors.surfaceDark
        chatContainer.layer.cornerRadius = Theme.CornerRadius.large
        contentView.addSubview(chatContainer)
        chatContainer.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(350)
        }
    }

    private func setupInput() {
        inputContainer.backgroundColor = Theme.Colors.surfaceDark
        view.addSubview(inputContainer)
        inputContainer.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }

        messageTextField.backgroundColor = Theme.Colors.backgroundDark
        messageTextField.textColor = Theme.Colors.textPrimaryDark
        messageTextField.font = Theme.Font.body()
        messageTextField.layer.cornerRadius = Theme.CornerRadius.medium
        messageTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        messageTextField.leftViewMode = .always
        messageTextField.placeholder = "Type your response..."
        messageTextField.attributedPlaceholder = NSAttributedString(string: "Type your response...", attributes: [.foregroundColor: Theme.Colors.textSecondaryDark])
        inputContainer.addSubview(messageTextField)
        messageTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        }

        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        sendButton.tintColor = Theme.Colors.primary
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        inputContainer.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.leading.equalTo(messageTextField.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(44)
        }
    }

    private func loadScenario(_ scenario: Scenario) {
        let initialMessage = ConversationMessage(role: "ai", content: "Welcome to the \(scenario.title) scenario. Let's practice together. Type your response when ready.")
        messages.append(initialMessage)
    }

    @objc private func sendMessage() {
        guard let text = messageTextField.text, !text.isEmpty else { return }

        let userMessage = ConversationMessage(role: "user", content: text)
        messages.append(userMessage)
        messageTextField.text = ""

        if let scenario = scenario {
            let aiResponse = viewModel.scenarioService.generateAIResponse(userMessage: text, scenario: scenario)
            let aiMessage = ConversationMessage(role: "ai", content: aiResponse)
            messages.append(aiMessage)
        }

        updateChat()
    }

    private func updateChat() {
        chatContainer.subviews.forEach { $0.removeFromSuperview() }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        chatContainer.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        for message in messages {
            let bubble = createBubble(message: message)
            stackView.addArrangedSubview(bubble)
        }
    }

    private func createBubble(message: ConversationMessage) -> UIView {
        let bubble = UIView()
        bubble.layer.cornerRadius = 12

        if message.role == "user" {
            bubble.backgroundColor = Theme.Colors.primary
        } else {
            bubble.backgroundColor = Theme.Colors.backgroundDark
        }

        let label = UILabel()
        label.text = message.content
        label.font = Theme.Font.body()
        label.textColor = Theme.Colors.textPrimaryDark
        label.numberOfLines = 0
        bubble.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        bubble.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(280)
        }

        return bubble
    }
}
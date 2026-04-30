import UIKit
import SnapKit

class JournalViewController: UIViewController {

    private let viewModel = JournalViewModel()

    private let headerLabel = UILabel()
    private let segmentedControl = UISegmentedControl(items: ["New Entry", "History"])
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let entryView = UIView()
    private let promptLabel = UILabel()
    private let textView = UITextView()
    private let emotionLabel = UILabel()
    private let emotionStackView = UIStackView()
    private let intensityLabel = UILabel()
    private let intensitySlider = UISlider()
    private let saveButton = UIButton(type: .system)
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        viewModel.loadEntries()
    }

    private func setupUI() {
        title = "Journal"
        view.backgroundColor = Theme.Colors.backgroundDark

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: Theme.Colors.textPrimary
        ]

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = Theme.Colors.backgroundCard
        segmentedControl.selectedSegmentTintColor = Theme.Colors.primary
        segmentedControl.setTitleTextAttributes([.foregroundColor: Theme.Colors.textSecondary], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }

        setupEntryView()
        setupHistoryTable()
        showEntryView()
    }

    private func setupEntryView() {
        contentView.addSubview(entryView)
        entryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Prompt
        promptLabel.text = "How are you feeling today?"
        promptLabel.font = Theme.Font.title3()
        promptLabel.textColor = Theme.Colors.textPrimary
        entryView.addSubview(promptLabel)
        promptLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        // Text View
        textView.backgroundColor = Theme.Colors.backgroundCard
        textView.textColor = Theme.Colors.textPrimary
        textView.font = Theme.Font.body()
        textView.layer.cornerRadius = Theme.CornerRadius.large
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.keyboardAppearance = .dark
        entryView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(promptLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(180)
        }

        // Emotions
        emotionLabel.text = "Select your emotions"
        emotionLabel.font = Theme.Font.subhead()
        emotionLabel.textColor = Theme.Colors.textSecondary
        entryView.addSubview(emotionLabel)
        emotionLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        emotionStackView.axis = .horizontal
        emotionStackView.spacing = Theme.Spacing.sm
        emotionStackView.distribution = .fillEqually
        entryView.addSubview(emotionStackView)
        emotionStackView.snp.makeConstraints { make in
            make.top.equalTo(emotionLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(60)
        }

        let emotions: [(Emotion, String)] = [(.happy, "😊"), (.calm, "😌"), (.anxious, "😰"), (.sad, "😢"), (.angry, "😠")]
        for (emotion, emoji) in emotions {
            let btn = createEmotionButton(emoji: emoji, emotion: emotion)
            emotionStackView.addArrangedSubview(btn)
        }

        // Intensity
        intensityLabel.text = "Intensity: 5"
        intensityLabel.font = Theme.Font.subhead()
        intensityLabel.textColor = Theme.Colors.textSecondary
        entryView.addSubview(intensityLabel)
        intensityLabel.snp.makeConstraints { make in
            make.top.equalTo(emotionStackView.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        intensitySlider.minimumValue = 1
        intensitySlider.maximumValue = 10
        intensitySlider.value = 5
        intensitySlider.tintColor = Theme.Colors.primary
        intensitySlider.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
        entryView.addSubview(intensitySlider)
        intensitySlider.snp.makeConstraints { make in
            make.top.equalTo(intensityLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }

        // Save Button
        saveButton.setTitle("Save Entry", for: .normal)
        saveButton.titleLabel?.font = Theme.Font.headline()
        saveButton.backgroundColor = Theme.Colors.primary
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = Theme.CornerRadius.large
        saveButton.addTarget(self, action: #selector(saveEntry), for: .touchUpInside)
        entryView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(intensitySlider.snp.bottom).offset(Theme.Spacing.xl)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.xl)
        }
    }

    private func createEmotionButton(emoji: String, emotion: Emotion) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(emoji, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 28)
        btn.backgroundColor = Theme.Colors.backgroundCard
        btn.layer.cornerRadius = Theme.CornerRadius.medium
        btn.tag = emotion.hashValue
        btn.addTarget(self, action: #selector(emotionTapped(_:)), for: .touchUpInside)
        return btn
    }

    private func setupHistoryTable() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(JournalEntryCell.self, forCellReuseIdentifier: JournalEntryCell.identifier)
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindData() {
        viewModel.onEntriesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func showEntryView() {
        entryView.isHidden = false
        tableView.isHidden = true
        scrollView.isHidden = false
    }

    private func showHistoryView() {
        entryView.isHidden = true
        tableView.isHidden = false
        scrollView.isHidden = false
    }

    @objc private func segmentChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            showEntryView()
        } else {
            showHistoryView()
        }
    }

    @objc private func emotionTapped(_ sender: UIButton) {
        let allEmotions = Emotion.allCases
        if let tappedEmotion = allEmotions.first(where: { $0.hashValue == sender.tag }) {
            viewModel.toggleEmotion(tappedEmotion)
            sender.backgroundColor = viewModel.selectedEmotions.contains(tappedEmotion)
                ? Theme.Colors.primary.withAlphaComponent(0.3)
                : Theme.Colors.backgroundCard
        }
    }

    @objc private func intensityChanged() {
        let value = Int(intensitySlider.value)
        intensityLabel.text = "Intensity: \(value)"
        viewModel.intensity = value
    }

    @objc private func saveEntry() {
        viewModel.entryText = textView.text
        viewModel.saveEntry()
        textView.text = ""
        let alert = UIAlertController(title: "Saved!", message: "Your journal entry has been saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JournalEntryCell.identifier, for: indexPath) as! JournalEntryCell
        cell.entry = viewModel.entries[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
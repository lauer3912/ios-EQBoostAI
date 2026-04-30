import UIKit
import SnapKit

class JournalViewController: UIViewController {

    private let viewModel = JournalViewModel()

    private let segmentedControl = UISegmentedControl(items: ["New Entry", "History"])
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let tableView = UITableView()

    private let entryView = UIView()
    private let textView = UITextView()
    private let emotionLabel = UILabel()
    private let emotionStackView = UIStackView()
    private let intensityLabel = UILabel()
    private let intensitySlider = UISlider()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        viewModel.loadEntries()
    }

    private func setupUI() {
        title = "Journal"
        view.backgroundColor = Theme.Colors.backgroundDark

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(toggleView))

        segmentedControl.selectedSegmentIndex = 0
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

        let placeholderLabel = UILabel()
        placeholderLabel.text = "What's on your mind today?"
        placeholderLabel.font = Theme.Font.body()
        placeholderLabel.textColor = Theme.Colors.textSecondaryDark
        textView.addSubview(placeholderLabel)

        textView.backgroundColor = Theme.Colors.surfaceDark
        textView.textColor = Theme.Colors.textPrimaryDark
        textView.font = Theme.Font.body()
        textView.layer.cornerRadius = Theme.CornerRadius.medium
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.delegate = self
        entryView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(200)
        }
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        emotionLabel.text = "How are you feeling?"
        emotionLabel.font = Theme.Font.heading3()
        emotionLabel.textColor = Theme.Colors.textPrimaryDark
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
            make.height.equalTo(50)
        }

        let emotions = [Emotion.happy, .calm, .anxious, .sad, .angry]
        for emotion in emotions {
            let card = EmotionCard()
            card.emotion = emotion
            card.isSelected = viewModel.selectedEmotions.contains(emotion)
            card.onTap = { [weak self] in
                self?.viewModel.toggleEmotion(emotion)
                self?.updateEmotionSelection()
            }
            emotionStackView.addArrangedSubview(card)
        }

        intensityLabel.text = "Intensity: 5/10"
        intensityLabel.font = Theme.Font.body()
        intensityLabel.textColor = Theme.Colors.textSecondaryDark
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

        saveButton.setTitle("Save Entry", for: .normal)
        saveButton.titleLabel?.font = Theme.Font.button()
        saveButton.backgroundColor = Theme.Colors.primary
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = Theme.CornerRadius.medium
        saveButton.addTarget(self, action: #selector(saveEntry), for: .touchUpInside)
        entryView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(intensitySlider.snp.bottom).offset(Theme.Spacing.xl)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.lg)
        }
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

    private func updateEmotionSelection() {
        for case let card as EmotionCard in emotionStackView.arrangedSubviews {
            if let emotion = card.emotion {
                card.isSelected = viewModel.selectedEmotions.contains(emotion)
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

    @objc private func toggleView() {
        segmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex == 0 ? 1 : 0
        segmentChanged()
    }

    @objc private func intensityChanged() {
        let value = Int(intensitySlider.value)
        intensityLabel.text = "Intensity: \(value)/10"
        viewModel.intensity = value
    }

    @objc private func saveEntry() {
        guard !textView.text.isEmpty else {
            showAlert(message: "Please write something before saving.")
            return
        }
        viewModel.entryText = textView.text
        viewModel.saveEntry()
        textView.text = ""
        showAlert(message: "Journal entry saved!")
        segmentedControl.selectedSegmentIndex = 1
        segmentChanged()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension JournalViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        for subview in textView.subviews where subview is UILabel {
            subview.isHidden = !textView.text.isEmpty
        }
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

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.viewModel.deleteEntry(at: indexPath.row)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
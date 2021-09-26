//
//  ViewController.swift
//  Pomodoro_Timer_App
//
//  Created by Ilya Protasov on 24.09.2021.
//

import UIKit

class ViewController: UIViewController {
    private var timer = Timer()
    private var timerTick = 0
    private var isStarted = false

    private var timerLimitInSeconds = TimerMetrics.workTimeInMinutes * 60

    private var isTimerRichLimit: Bool {
        get {
            return timerTick >= Int(timerLimitInSeconds)
        }
    }

    private lazy var timerLabel: UILabel = {
        let label = UILabel()

        label.text = "00:00"
        label.font = .systemFont(ofSize: Metrics.timerLabelFonSize, weight: .medium)
        label.textColor = TimerMetrics.workStateTimerColor
        label.textAlignment = .center

        return label
    }()

    private lazy var timerButton: UIButton = {
        var button = UIButton(type: .system)

        setPlayImage(for: button, with: TimerMetrics.workStateTimerColor)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(timerButtonPressed), for: .touchUpInside)

        return button
    }()

    private lazy var parentStackView: UIStackView = {
        var stackView = UIStackView()

        stackView.axis = .vertical

        return stackView
    }()

    private lazy var circleView: UIView = {
        var cirlceView = UIView()

        return cirlceView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupView()
    }

    private func setupHierarchy() {
        view.addSubview(parentStackView)

        parentStackView.addArrangedSubview(timerLabel)
        parentStackView.addArrangedSubview(timerButton)
    }

    private func setupLayout() {
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        parentStackView.center = self.view.center

        parentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18).isActive = true
        parentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18).isActive = true
        parentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300).isActive = true
    }

    private func setupView() {
        view.backgroundColor = Metrics.backgroundColor
    }

    // MARK: - Private functions

    private func setPlayImage(for button: UIButton, with color: UIColor) {
        setImage(name: "play", with: color, for: button)
    }

    private func setPauseImage(for button: UIButton, with color: UIColor) {
        setImage(name: "pause", with: color, for: button)
    }

    private func setImage(name: String, with color: UIColor, for button: UIButton) {
        button.setImage(UIImage(systemName: name)?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
    }

    //MARK: - ObjC functions

    @objc func timerButtonPressed() {
        if !isStarted && !isTimerRichLimit {
            setPauseImage(for: timerButton, with: TimerMetrics.workStateTimerColor)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tickTimer), userInfo: nil, repeats: true)
            isStarted = true
        } else {
            setPlayImage(for: timerButton, with: TimerMetrics.workStateTimerColor)
            timer.invalidate()
            isStarted = false
        }
    }

    @objc func tickTimer() {
        timerTick += 1
        let timerData = TimeData(seconds: timerTick)
        timerLabel.text = timerData.toTimeString()

        if isTimerRichLimit {
            timer.invalidate()
        }
    }
}

// MARK: - Constants
extension ViewController {
    enum TimerMetrics {
        static let restTimeInMinutes: CGFloat = 5
        static let workTimeInMinutes: CGFloat = 0.25
        static let workStateTimerColor: UIColor = .green
    }

    enum Metrics {
        static let backgroundColor: UIColor = .black
        static let timerLabelFonSize: CGFloat = 70
        static let timerLabelTextColor: UIColor = .green
    }
}

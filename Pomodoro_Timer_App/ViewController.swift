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
    private var isWorkTime = true

    private var timerLimitInSeconds: CGFloat {
        if isWorkTime {
            return TimerMetrics.workTimeInMinutes * 60
        }

        return TimerMetrics.restTimeInMinutes * 60
    }

    private var isTimerRichLimit: Bool {
        get {
            return timerTick >= Int(timerLimitInSeconds)
        }
    }

    private var timerColor: UIColor {
        get {
            if isWorkTime {
                return TimerMetrics.workStateTimerColor
            }

            return TimerMetrics.restStateTimerColor
        }
    }

    private lazy var timerLabel: UILabel = {
        let label = UILabel()

        label.text = "00:00"
        label.font = .systemFont(ofSize: Metrics.timerLabelFonSize, weight: .medium)
        label.textColor = timerColor
        label.textAlignment = .center

        return label
    }()

    private lazy var timerButton: UIButton = {
        var button = UIButton(type: .system)

        setPlayImage(for: button, with: timerColor)
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
            startTimer()
        } else {
            pauseTimer()
        }
    }

    @objc func tickTimer() {
        timerTick += 1
        var timerData = TimeData(seconds: timerTick)
        timerLabel.text = timerData.toTimeString()

        if isTimerRichLimit {
            timer.invalidate()
            isWorkTime = !isWorkTime
            timerTick = 0

            timerData = TimeData(seconds: timerTick)
            timerLabel.text = timerData.toTimeString()

            timerLabel.textColor = timerColor

            startTimer()
        }
    }

    private func startTimer() {
        setPauseImage(for: timerButton, with: timerColor)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tickTimer), userInfo: nil, repeats: true)
        isStarted = true
    }

    private func pauseTimer() {
        setPlayImage(for: timerButton, with: timerColor)
        timer.invalidate()
        isStarted = false
    }
}

// MARK: - Constants
extension ViewController {
    enum TimerMetrics {
        static let restTimeInMinutes: CGFloat = 5
        static let workTimeInMinutes: CGFloat = 25
        static let workStateTimerColor: UIColor = .green
        static let restStateTimerColor: UIColor = .red
    }

    enum Metrics {
        static let backgroundColor: UIColor = .black
        static let timerLabelFonSize: CGFloat = 70
        static let timerLabelTextColor: UIColor = .green
    }
}

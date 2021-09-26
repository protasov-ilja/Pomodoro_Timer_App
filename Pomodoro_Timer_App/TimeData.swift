//
//  TimeData.swift
//  Pomodoro_Timer_App
//
//  Created by Ilya Protasov on 25.09.2021.
//

import Foundation

struct TimeData {
    public var seconds: Int
    public var minutes: Int

    init(seconds: Int) {
        self.seconds = seconds % 3600 % 60
        minutes = seconds % 3600 / 60
    }

    public func toTimeString() -> String {
        return "\(getTimeFormatStringFrom(self.minutes)):\(getTimeFormatStringFrom(self.seconds))"
    }

    private func getTimeFormatStringFrom(_ value: Int) -> String {
        return value < 10 ? "0\(value)" : "\(value)"
    }
}

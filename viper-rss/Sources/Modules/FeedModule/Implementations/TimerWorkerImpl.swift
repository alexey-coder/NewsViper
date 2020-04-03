//
//  TimerWorkerImpl.swift
//  viper-rss
//
//  Created by user on 03.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

private struct Metrics {
    struct Values {
        static let defaultSeconds = Constants.DefaultValues.timerDefault
    }
}

final class TimerWorkerImpl: TimerWorkerProtocol {
    var onOverTimer: (() -> Void)?
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    private let defaultSeconds = Metrics.Values.defaultSeconds
    private var timer: Timer?
    private var seconds: Int?
    
    init(userDefaultsStorage: UserDefaultsStorageProtocol) {
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    func startTimer() {
        let secondsFromSettings = userDefaultsStorage.savedTimerValue()
        seconds = secondsFromSettings == nil ? defaultSeconds : secondsFromSettings
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.update()
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    private func update() {
        guard var seconds = self.seconds else {
            return
        }
        seconds -= 1
        self.seconds = seconds
        if seconds <= 0 {
            stopTimer()
            startTimer()
            onOverTimer?()
        }
    }
}

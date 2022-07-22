//
//  TimerClass.swift
//  Focus
//
//  Created by Aahish Balimane on 4/4/22.
//

import Foundation

class TimerClass: ObservableObject {
    @Published var minutes: Int
    @Published var hours: Int
    @Published var seconds: Int
    
    init(minutes: Int, hours: Int) {
        self.minutes = minutes
        self.hours = hours
        self.seconds = 0
    }
    
    func startTimer(hours: Int, minutes: Int) {
        self.hours = hours
        self.minutes = minutes
        var timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { tmr in
            if self.hours == 0 && self.minutes == 0 && self.seconds == 0 {
                tmr.invalidate()
                var focusTime: Double = UserDefaults.standard.double(forKey: "focusHrs")
                if hours == 0 && focusTime < 60 {
                    focusTime += Double(minutes)
                } else {
                    focusTime += Double(hours + (minutes / 60))
                }
                UserDefaults.standard.set(focusTime, forKey: "focusHrs")
            } else {
                if self.hours == 0 {
                    if self.minutes == 0 {
                        self.seconds -= 1
                    } else {
                        if self.seconds == 0 {
                            self.seconds = 59
                            self.minutes -= 1
                        } else {
                            self.seconds -= 1
                        }
                    }
                } else {
                    if self.minutes == 0 {
                        if self.seconds == 0 {
                            self.minutes = 59
                            self.seconds = 59
                        } else {
                            self.seconds -= 1
                        }
                    } else {
                        if self.seconds == 0 {
                            self.seconds = 59
                            self.minutes -= 1
                        } else {
                            self.seconds -= 1
                        }
                    }
                }
            }
        })
    }
    
}

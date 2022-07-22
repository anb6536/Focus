//
//  TimerView.swift
//  Focus
//
//  Created by Aahish Balimane on 4/4/22.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var timerClass: TimerClass
    var alertShown: Binding<Bool>
    
    init(seconds: Binding<Double>, isFocusMode: Bool, alertShown: Binding<Bool>) {
        let totalMinutes = Int(seconds.wrappedValue/60)
        let hours = Int(totalMinutes/60)
        let minutes = Int(totalMinutes%60)
        
        timerClass = TimerClass(minutes: minutes, hours: hours)
        self.alertShown = alertShown
        if(isFocusMode) {
            timerClass.startTimer(hours: hours, minutes: minutes)
        }
        
    }
    
    var body: some View {
        Text("\(timerClass.hours) hours : \(timerClass.minutes) min : \(timerClass.seconds) s")
            .padding()
            .onChange(of: timerClass.seconds) { newValue in
                if timerClass.seconds == 0 && timerClass.minutes == 0 && timerClass.hours == 0{
                    print("Time Over")
                    alertShown.wrappedValue.toggle()
                }
            }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(seconds: .constant(0), isFocusMode: false, alertShown: .constant(false))
    }
}

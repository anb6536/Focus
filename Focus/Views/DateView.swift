//
//  DateView.swift
//  Focus
//
//  Created by Aahish Balimane on 4/4/22.
//

import Foundation
import SwiftUI
import UIKit

struct DateView: UIViewRepresentable {
    @Binding var duration: Double
    let datePicker = UIDatePicker()
    
    func makeUIView(context: Context) -> UIDatePicker {
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .automatic
        DispatchQueue.main.async {
           
            datePicker.minuteInterval = 1
            datePicker.countDownDuration = 0
        
        }
        datePicker.addTarget(context.coordinator, action: #selector(DateView.Coordinator.didSelectTime), for: .valueChanged)
        return datePicker
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
//        duration = datePicker.countDownDuration
    }

    func makeCoordinator() -> DateView.Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UIPickerViewDelegate {
        var parent: DateView
        init(_ dateView: DateView) {
            self.parent = dateView
        }
        @IBAction func didSelectTime() {
            parent.duration = parent.datePicker.countDownDuration
        }
    }
}


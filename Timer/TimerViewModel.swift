//
//  TimerViewModel.swift
//  Timer
//
//  Created by Alexandre Samson on 09.09.24.
//

import Foundation

class TimerViewModel: ObservableObject {
    @Published var stunden = 0
    @Published var minuten = 0
    @Published var sekunden = 0
    
    private var stundenInitial = 0
    private var minutenInitial = 0
    private var sekundenInitial = 0
    
    @Published var time = "00:00:00"
    @Published var progress = 0.0
    @Published var isActive = false
    
    private var endDate = Date()
    private var timerDuration = 0.0
    
    func start() {
        isActive = true
        
        let calendar = Calendar.current
        endDate = Date()

        endDate = calendar.date(byAdding: .hour, value: stunden, to: endDate)!
        endDate = calendar.date(byAdding: .minute, value: minuten, to: endDate)!
        endDate = calendar.date(byAdding: .second, value: sekunden, to: endDate)!
        
        stundenInitial = stunden
        minutenInitial = minuten
        sekundenInitial = sekunden
        
        timerDuration = endDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        
        update()
    }
    
    func reset() {
        isActive = false
        stunden = stundenInitial
        minuten = minutenInitial
        sekunden = sekundenInitial
        progress = 0
    }
    
    func update() {
        let diff = endDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        
        if diff <= 0 {
            isActive = false
            return
        }
        
        let date = Date(timeIntervalSince1970: diff)
        
        let calendar = Calendar.current
        
        let verbleibendeStunden = Int(diff/60/60) //calendar.component(.hour, from: date)
        let verbleibendeMinuten = calendar.component(.minute, from: date)
        let verbleibendeSekunden = calendar.component(.second, from: date)
        print(verbleibendeStunden)
        
        progress = diff / timerDuration
        time = String(format: "%d:%02d:%02d", verbleibendeStunden, verbleibendeMinuten, verbleibendeSekunden)
    }
}


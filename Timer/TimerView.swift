//
//  ContentView.swift
//  Timer
//
//  Created by Alexandre Samson on 09.09.24.
//

import SwiftUI

struct TimerView: View {
    
    @StateObject private var timerVM = TimerViewModel()
    
    var body: some View {
        if timerVM.isActive {
            TimerCountdownView(timerVM: timerVM)
                .frame(width: 350)
        } else {
            VStack {
                TimerSelectionView(timerVM: timerVM)
                    .frame(width: 300)
                Button("Start") {
                    timerVM.start()
                }
                .padding(.top)
            }
        }
    }
}

struct TimerSelectionView: View {
    
    @ObservedObject var timerVM: TimerViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Text("Std.")
                    .offset(x: 40)
                Picker("Stunden", selection: $timerVM.stunden) {
                    ForEach(0..<24) { stunde in
                        Text(String(stunde))
                            .tag(stunde)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding(.trailing, -16)
                .clipped()
            }
            ZStack {
                Text("Min.")
                    .offset(x: 33)
                Picker("Minuten", selection: $timerVM.minuten) {
                    ForEach(0..<60) { minute in
                        Text(String(minute))
                            .tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding(.horizontal, -16)
                .clipped()
            }
            ZStack {
                Text("Sek.")
                    .offset(x: 25)
                Picker("Sekunden", selection: $timerVM.sekunden) {
                    ForEach(0..<60) { minute in
                        Text(String(minute))
                            .tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding(.leading, -16)
                .clipped()
            }
        }
    }
}

struct TimerCountdownView: View {
    
    @ObservedObject var timerVM: TimerViewModel
    
    private let timer = Timer.publish(
        every: 0.016,
        on: .main,
        in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            CircleProgressView(timerVM: timerVM)
            VStack {
                Text(timerVM.time)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Button("Reset") {
                    timerVM.reset()
                }
                .padding(.top)
            }
        }
        .onReceive(timer) { _ in
            timerVM.update()
        }
    }
}

struct CircleProgressView: View {
    
    @ObservedObject var timerVM: TimerViewModel
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    .gray.opacity(0.2),
                    style: StrokeStyle(lineWidth: 10)
                )
            Circle()
                .trim(from: 0, to: timerVM.progress)
                .stroke(
                    .orange,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
            
    }
}

#Preview {
    TimerView()
}

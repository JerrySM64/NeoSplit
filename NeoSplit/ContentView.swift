//
//  ContentView.swift
//  NeoSplit
//
//  Created by Jerry on 29/07/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerManager: TimerManager
    @StateObject private var keyEventHandler = KeyEventHandler()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(timerManager.gameName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding([.top, .leading, .trailing])
                
                Text(timerManager.category)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding([.leading, .trailing, .bottom])
            }
            .background(Color.black)
            .cornerRadius(10)
            .padding()
            
            Text(timerManager.elapsedTimeString)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundStyle(.green)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .padding()
            
            HStack {
                Button(action: {
                    timerManager.start()
                }) {
                    Text("Start")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LiveSplitButtonStyle())
                
                Button(action: {
                    timerManager.stop()
                }) {
                    Text("Stop")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LiveSplitButtonStyle())
                
                Button(action: {
                    timerManager.reset()
                }) {
                    Text("Reset")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LiveSplitButtonStyle())
            }
            .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .onAppear {
            keyEventHandler.timerManager = timerManager
            updateKeyBindings()
            NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main) { _ in
                updateKeyBindings()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
        }
    }
    
    private func updateKeyBindings() {
        let startKey = UserDefaults.standard.string(forKey: "startKey") ?? "S"
        let stopKey = UserDefaults.standard.string(forKey: "stopKey") ?? "T"
        let resetKey = UserDefaults.standard.string(forKey: "resetKey") ?? "R"
        
        keyEventHandler.updateKeyBindings(startKey: startKey, stopKey: stopKey, resetKey: resetKey)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerManager())
    }
}

struct LiveSplitButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.black)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

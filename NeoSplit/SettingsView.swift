//
//  SettingsView.swift
//  NeoSplit
//
//  Created by Jerry on 30/07/2024.
//

import SwiftUI
import AppKit

struct SettingsView: View {
    @AppStorage("startKey") private var startKey: String = "S"
    @AppStorage("stopKey") private var stopKey: String = "T"
    @AppStorage("resetKey") private var resetKey: String = "R"
    @EnvironmentObject var timerManager: TimerManager
    @State private var gameName: String = UserDefaults.standard.string(forKey: "gameName") ?? ""
    @State private var category: String = UserDefaults.standard.string(forKey: "category") ?? ""
    @State private var backgroundColor: Color = Color(UserDefaults.standard.color(forKey: "backgroundColor") ?? .gray)
    @State private var textColor: Color = Color(UserDefaults.standard.color(forKey: "textColor") ?? .white)
    @State private var timerColor: Color = Color(UserDefaults.standard.color(forKey: "timerColor") ?? .green)
    @State private var selectedFontName: String = UserDefaults.standard.string(forKey: "selectedFontName") ?? "Helvetica"
    @State private var splits: [Split] = UserDefaults.standard.splits(forKey: "splits") ?? [Split(name: "Split 1")]
    
    private let fontNames = ["Helvetica", "Arial", "Courier", "Times New Roman"]

    var body: some View {
        Form {
            Section(header: Text("Game Settings").font(.headline).foregroundColor(textColor)) {
                TextField("Game", text: $gameName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: gameName) { newValue in
                        timerManager.saveGameName(newValue)
                    }
                TextField("Category", text: $category)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: category) { newValue in
                        timerManager.saveCategory(newValue)
                    }
            }
            .listRowBackground(backgroundColor)
            
            Section(header: Text("Splits").font(.headline).foregroundColor(textColor)) {
                ForEach($splits) { $split in
                    TextField("Split Name", text: $split.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: split.name) { newValue in
                            timerManager.updateSplits(splits)
                        }
                }
                HStack {
                    Button(action: {
                        splits.append(Split(name: "New Split"))
                    }) {
                        Text("Add Split")
                    }
                    Button(action: {
                        if !splits.isEmpty {
                            splits.removeLast()
                            timerManager.updateSplits(splits)
                        }
                    }) {
                        Text("Delete Split")
                            .foregroundStyle(.red)
                    }
                }
            }

            Section(header: Text("Key Bindings").font(.headline).foregroundColor(textColor)) {
                HStack {
                    Text("Start").foregroundColor(textColor)
                    TextField("", text: $startKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Stop").foregroundColor(textColor)
                    TextField("", text: $stopKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Reset").foregroundColor(textColor)
                    TextField("", text: $resetKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .listRowBackground(backgroundColor)

            Section(header: Text("User Interface").font(.headline).foregroundColor(textColor)) {
                ColorPicker("Background Color", selection: $backgroundColor)
                    .onChange(of: backgroundColor) { newValue in
                        UserDefaults.standard.set(newValue.toNSColorData(), forKey: "backgroundColor")
                    }
                ColorPicker("Text Color", selection: $textColor)
                    .onChange(of: textColor) { newValue in
                        UserDefaults.standard.set(newValue.toNSColorData(), forKey: "textColor")
                    }
                ColorPicker("Timer Color", selection: $timerColor)
                    .onChange(of: timerColor) { newValue in
                        UserDefaults.standard.set(newValue.toNSColorData(), forKey: "timerColor")
                    }
                Picker("Font", selection: $selectedFontName) {
                    ForEach(fontNames, id: \.self) { fontName in
                        Text(fontName).tag(fontName)
                    }
                }
                .onChange(of: selectedFontName) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "selectedFontName")
                }
            }
            .listRowBackground(backgroundColor)
        }
        .padding()
        .onAppear {
            gameName = timerManager.gameName
            category = timerManager.category
            splits = UserDefaults.standard.splits(forKey: "splits") ?? [Split(name: "Split 1")]
        }
        .onChange(of: splits) { newValue in
            UserDefaults.standard.setSplits(newValue, forKey: "splits")
            timerManager.updateSplits(newValue)
        }
        .frame(minWidth: 450, minHeight: 600)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(TimerManager())
    }
}

extension UserDefaults {
    func color(forKey key: String) -> NSColor? {
        if let data = data(forKey: key) {
            do {
                return try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data)
            } catch {
                print("Error retrieving color for key \(key): \(error)")
                return nil
            }
        }
        return nil
    }

    func set(_ value: NSColor?, forKey key: String) {
        guard let value = value else {
            removeObject(forKey: key)
            return
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch {
            print("Error setting color for key \(key): \(error)")
        }
    }
    
    func splits(forKey key: String) -> [Split]? {
        if let data = data(forKey: key) {
            let decoder = JSONDecoder()
            return try? decoder.decode([Split].self, from: data)
        }
        return nil
    }

    func setSplits(_ splits: [Split], forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(splits) {
            set(data, forKey: key)
        }
    }
}

extension Color {
    func toNSColor() -> NSColor {
        let components = self.cgColor?.components ?? [0, 0, 0, 1]
        return NSColor(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }

    func toNSColorData() -> Data? {
        let nsColor = self.toNSColor()
        return try? NSKeyedArchiver.archivedData(withRootObject: nsColor, requiringSecureCoding: false)
    }
}

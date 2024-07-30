//
//  SettingsView.swift
//  NeoSplit
//
//  Created by Jerry on 30/07/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("startKey") private var startKey: String = "S"
    @AppStorage("stopKey") private var stopKey: String = "T"
    @AppStorage("resetKey") private var resetKey: String = "R"
    
    var body: some View {
        Form {
            Section(header: Text("Key Bindings")) {
                HStack {
                    Text("Start")
                    TextField("", text: $startKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                }
                HStack {
                    Text("Stop")
                    TextField("", text: $stopKey)
                        .frame(width: 50)
                    multilineTextAlignment(.center)
                }
                HStack {
                    Text("Reset")
                    TextField("", text: $resetKey)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
        .frame(width: 300, height: 150)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

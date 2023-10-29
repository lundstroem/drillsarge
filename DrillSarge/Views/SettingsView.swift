//
//  SettingsView.swift
//  DrillSarge
//
//  Created by Harry Lundström on 2023-10-29.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var programRunner: ProgramRunner

    var body: some View {
        Form {
            Section {
                TextField(
                    modelData.previewText,
                    text: $modelData.previewText
                ).textFieldStyle(.plain)
                Picker("voice", selection: $programRunner.selectedVoice) {
                    ForEach(modelData.voices) { voice in
                        let string = "\(voice.speechVoice.name) \(voice.speechVoice.language)"
                        Text(string).tag(voice)
                    }
                }
                Button {
                    programRunner.preview(text: modelData.previewText, voice: programRunner.selectedVoice.speechVoice)
                } label: {
                    Label("preview", systemImage: "play")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

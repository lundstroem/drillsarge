//
//  SettingsView.swift
//  DrillSarge
//
//  Created by Harry Lundström on 2023-10-29.
//

import SwiftUI

struct SettingsView: View {

    @Bindable var modelData: ModelData

    var body: some View {
        Form {
            Section {
                TextField(
                    modelData.previewText,
                    text: $modelData.previewText
                ).textFieldStyle(.plain)
                Picker("voice", selection: $modelData.programRunner.selectedVoice) {
                    ForEach(modelData.voices) { voice in
                        let string = "\(voice.speechVoice.name) \(voice.speechVoice.language)"
                        Text(string).tag(voice)
                    }
                }.onChange(of: modelData.programRunner.selectedVoice) { oldState, newState in
                    modelData.persistentStorage.voiceName = newState.speechVoice.name
                }

                Button {
                    modelData.programRunner.preview(text: modelData.previewText, voice: modelData.programRunner.selectedVoice.speechVoice)
                } label: {
                    Label("preview", systemImage: "play")
                }
            }
        }
    }
}

#Preview {
    SettingsView(modelData: ModelData())
}


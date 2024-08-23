//
//  ModelData.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import Foundation
import AVFoundation

@Observable final class ModelData {

    var programRunner: ProgramRunner = ProgramRunner()
    let persistentStorageKey: String = "persistentStorageKey"
    var persistentStorage: PersistentStorage = PersistentStorage()

    var previewText: String = "testing"

    var voices: [Voice] = {
        var voicesArray: [Voice] = []
        for speechVoice in AVSpeechSynthesisVoice.speechVoices() {
            voicesArray.append(Voice(speechVoice: speechVoice))
        }
        return voicesArray
    }()

    func updateExercise(exercise: Exercise) {
        for (programIndex, program) in persistentStorage.programs.enumerated() {
            for (exerciseIndex, storedExercise) in program.exercises.enumerated() {
                if (storedExercise.id == exercise.id) {
                    persistentStorage.programs[programIndex].exercises[exerciseIndex] = exercise
                }
            }
        }
    }

    func storeData() {
        let jsonEncoder = JSONEncoder()
        var jsonData: Data?
        do {
            jsonData = try jsonEncoder.encode(persistentStorage)
        } catch {
            print("Unexpected error: \(error).")
        }

        if let jsonData = jsonData {
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("jsonString:\(jsonString ?? "")")

            let defaults = UserDefaults.standard
            defaults.set(jsonString, forKey: persistentStorageKey)
        }
    }

    func loadData() {

        // TODO: Add unit tests for save and load.
        // - Can it handle migrating from an old structure to a new? (With new fields not existing in the json data).
        // backwards compat check.

        let defaults = UserDefaults.standard

        if let jsonString: String = defaults.object(forKey: persistentStorageKey) as? String {
            if let data = jsonString.data(using: .utf8) {
                let persistentStorage: PersistentStorage = try! JSONDecoder().decode(PersistentStorage.self, from: data)
                print("loadedPrograms: \(persistentStorage.programs.count)")
                self.persistentStorage = persistentStorage

                // update voiceName from storage
                for voice in voices {
                    if voice.speechVoice.name == persistentStorage.voiceName {
                        programRunner.selectedVoice = voice
                    }
                }
            }
        }
    }
}

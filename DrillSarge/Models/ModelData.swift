/*

 MIT License

 Copyright (c) 2024 Harry Lundström

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

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

        let defaults = UserDefaults.standard

        if let jsonString: String = defaults.object(forKey: persistentStorageKey) as? String {
            if let data = jsonString.data(using: .utf8) {
                let persistentStorage: PersistentStorage = try! JSONDecoder().decode(PersistentStorage.self, from: data)
                print("loadedPrograms: \(persistentStorage.programs.count)")
                self.persistentStorage = persistentStorage

                // update voiceName from storage
                for voice in voices {
                    if voice.speechVoice.name+voice.speechVoice.language == persistentStorage.voiceName {
                        programRunner.selectedVoice = voice
                    }
                }
            }
        }
    }
}

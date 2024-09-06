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

@Observable final class ProgramRunner: NSObject {

    enum SpeakFinishedAction {
        case none
        case runExercise
    }

    var isRunningProgram: Bool = false
    var currentExerciseName: String = ""
    var durationLeftSeconds: Int = 0
    var selectedVoice = Voice(speechVoice: AVSpeechSynthesisVoice.speechVoices().first ?? AVSpeechSynthesisVoice())

    private var currentProgram: Program?
    private var currentExerciseIndex: Int = 0
    private var currentSpeakFinishedAction: SpeakFinishedAction = .none
    private var timer: Timer?
    private var durationRestSeconds: Int = 0

    private var utterance: AVSpeechUtterance?
    private let synthesizer = AVSpeechSynthesizer()

    func run(program: Program, shuffle: Bool = false) {
        currentProgram = program
        if shuffle {
            currentProgram?.exercises.shuffle()
        }
        startExercise()
    }

    func stop() {
        isRunningProgram = false
        stopProgram()
    }

    func preview(text: String, voice: AVSpeechSynthesisVoice? = nil) {
        speak(text: text, voice: voice)
    }
}

// MARK: - Timer callback

private extension ProgramRunner {

    @objc func fireTimer() {
        if durationRestSeconds > 0 {
            durationRestSeconds -= 1

            if durationRestSeconds == 0 {
                currentExerciseIndex += 1
                startExercise()
            }
            return
        }

        durationLeftSeconds -= 1
        if durationLeftSeconds < 11 {
            if durationLeftSeconds == 0 {
                speak(text: "done")
            } else {
                speak(text: "\(durationLeftSeconds)")
            }
        }

        if durationLeftSeconds == 0 {
            durationRestSeconds = 4
        }
    }
}

// MARK: - Private

private extension ProgramRunner {

    private func stopProgram() {
        timer?.invalidate()
        timer = nil

        synthesizer.stopSpeaking(at: .immediate)

        isRunningProgram = false
        durationLeftSeconds = 0
        currentExerciseIndex = 0
        currentExerciseName = ""
        currentProgram = nil

        currentSpeakFinishedAction = .none
    }

    private func speak(text: String, voice: AVSpeechSynthesisVoice? = nil) {
        utterance = AVSpeechUtterance(string: text)
        utterance?.voice = voice ?? selectedVoice.speechVoice
        utterance?.rate = 0.5
        utterance?.pitchMultiplier = 1.0

        if let utterance = utterance {
            synthesizer.delegate = self
            synthesizer.speak(utterance)
        }
    }

    private func startExercise() {

        timer?.invalidate()
        timer = nil

        if let exerciseCount = currentProgram?.exercises.count,
           currentExerciseIndex < exerciseCount,
           let currentExercise = currentProgram?.exercises[currentExerciseIndex] {
            let text = "\(currentExercise.name) \(currentExercise.duration) seconds. Ready... Start"
            speak(text: text)
            currentExerciseName = currentExercise.name
            durationLeftSeconds = currentExercise.duration
            currentSpeakFinishedAction = .runExercise
        } else {
            speak(text: "program finished")
            stopProgram()
        }
    }

    private func runExercise() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ProgramRunner.fireTimer), userInfo: nil, repeats: true)
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension ProgramRunner: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        switch currentSpeakFinishedAction {
        case .none:
            break
        case .runExercise:
            runExercise()
        }
        currentSpeakFinishedAction = .none
    }
}

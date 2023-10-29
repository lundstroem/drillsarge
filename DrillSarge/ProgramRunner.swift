//
//  ProgramRunner.swift
//  DrillSarge
//
//  Created by user on 2023-10-07.
//

import Foundation
import AVFoundation

final class ProgramRunner: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {

    enum SpeakFinishedAction {
        case none
        case runExercise
    }

    @Published var durationLeft: Int = 0
    @Published var currentExerciseName: String = ""

    // TODO: Add persistence for selectedVoice.
    @Published var selectedVoice = Voice(speechVoice: AVSpeechSynthesisVoice.speechVoices().first ?? AVSpeechSynthesisVoice())

    var currentProgram: Program?
    var currentExerciseIndex: Int = 0
    var currentSpeakFinishedAction: SpeakFinishedAction = .none
    var timer: Timer?
    var durationRest = 0

    var utterance: AVSpeechUtterance?
    let synthesizer = AVSpeechSynthesizer()

    func run(program: Program, shuffle: Bool = false) {
        currentProgram = program
        if shuffle {
            currentProgram?.exercises.shuffle()
        }
        startExercise()
    }

    func stop() {
        stopProgram()
    }

    func preview(text: String, voice: AVSpeechSynthesisVoice? = nil) {
        speak(text: text, voice: voice)
    }

    private func stopProgram() {
        timer?.invalidate()
        timer = nil

        synthesizer.stopSpeaking(at: .immediate)
        durationLeft = 0
        currentExerciseIndex = 0
        currentExerciseName = ""
        currentProgram = nil
    }

    private func speak(text: String, voice: AVSpeechSynthesisVoice? = nil) {
        // TODO: Add more speech options.
        utterance = AVSpeechUtterance(string: text)
        utterance?.voice = voice ?? selectedVoice.speechVoice
        utterance?.rate = 0.3
        utterance?.pitchMultiplier = 0.3

        if let utterance = utterance {
            synthesizer.delegate = self
            synthesizer.speak(utterance)
        }
    }

    func startExercise() {

        timer?.invalidate()
        timer = nil

        if let exerciseCount = currentProgram?.exercises.count,
           currentExerciseIndex < exerciseCount,
           let currentExercise = currentProgram?.exercises[currentExerciseIndex] {
            let text = "\(currentExercise.name) \(currentExercise.duration) seconds. Ready... Start"
            speak(text: text)
            currentExerciseName = currentExercise.name
            currentSpeakFinishedAction = .runExercise
        } else {
            speak(text: "program finished")
            stopProgram()
        }
    }

    func runExercise() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ProgramRunner.fireTimer), userInfo: nil, repeats: true)
        if let initialExercise = currentProgram?.exercises.first {
            durationLeft = initialExercise.duration
        }
    }

    @objc func fireTimer() {
        if durationRest > 0 {
            durationRest -= 1

            if durationRest == 0 {
                currentExerciseIndex += 1
                startExercise()
            }
            return
        }

        durationLeft -= 1
        if durationLeft < 11 {
            if durationLeft == 0 {
                speak(text: "done")
            } else {
                speak(text: "\(durationLeft)")
            }
        }

        if durationLeft == 0 {
            // TODO: Add variable rest time per exercise?
            durationRest = 4
        }
    }

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

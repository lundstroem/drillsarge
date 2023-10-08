//
//  ProgramRunner.swift
//  DrillSarge
//
//  Created by user on 2023-10-07.
//

import Foundation
import AVFoundation

class ProgramRunner: NSObject, AVSpeechSynthesizerDelegate {
    
    enum SpeakFinishedAction {
        case none
        case runExercise
    }

    private static let instance = ProgramRunner()

    var currentProgram: Program?
    var currentExerciseIndex: Int = 0
    var currentSpeakFinishedAction: SpeakFinishedAction = .none
    var timer: Timer?
    var durationLeft = 0
    var durationRest = 0

    var utterance: AVSpeechUtterance?
    let synthesizer = AVSpeechSynthesizer()

    static func run(program: Program, shuffle: Bool = false) {
        instance.currentProgram = program
        if shuffle {
            instance.currentProgram?.exercises.shuffle()
        }
        instance.startExercise()
    }

    static func stop() {
        instance.stopProgram()
    }

    private func stopProgram() {
        timer?.invalidate()
        timer = nil

        durationLeft = 0
        currentExerciseIndex = 0
        currentProgram = nil
    }

    func startExercise() {

        timer?.invalidate()
        timer = nil

        if let exerciseCount = currentProgram?.exercises.count,
           currentExerciseIndex < exerciseCount,
           let currentExercise = currentProgram?.exercises[currentExerciseIndex] {
            speak(text: "\(currentExercise.name) \(currentExercise.duration) seconds. Ready... Start")
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

    private func speak(text: String) {
        // TODO: Add more speech options.
        utterance = AVSpeechUtterance(string: text)
        utterance?.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance?.rate = 0.3

        if let utterance = utterance {
            synthesizer.delegate = self
            synthesizer.speak(utterance)
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("speechSynthesizer didFinish")
       
        switch currentSpeakFinishedAction {
        case .none:
            break
        case .runExercise:
            runExercise()
        }

        currentSpeakFinishedAction = .none
    }

}

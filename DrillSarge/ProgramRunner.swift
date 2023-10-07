//
//  ProgramRunner.swift
//  DrillSarge
//
//  Created by user on 2023-10-07.
//

import Foundation
import AVFoundation

class ProgramRunner: NSObject, AVSpeechSynthesizerDelegate {

    private static let instance = ProgramRunner()

    var currentProgram: Program?
    var currentExerciseIndex: Int = 0
    var timer: Timer?
    var durationLeft = 0

    var utterance: AVSpeechUtterance?
    let synthesizer = AVSpeechSynthesizer()

    static func run(program: Program) {
        //instance.runProgram(program: program)
        instance.speak(text: "testing")
    }

    static func stop() {
        instance.stopProgram()
    }

    private func stopProgram() {
        timer = nil
        durationLeft = 0
        currentExerciseIndex = 0
        currentProgram = nil
    }

    private func runProgram(program: Program) {
        currentProgram = program
        currentExerciseIndex = 0

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ProgramRunner.fireTimer), userInfo: nil, repeats: true)
        if let initialExercise = program.exercises.first {
            durationLeft = initialExercise.duration
        }
    }

    @objc func fireTimer() {
        print("Timer fired!")
        
        durationLeft -= 1
        if durationLeft < 11 {
            speak(text: "\(durationLeft)")
        }

        if durationLeft == 0 {
            // TODO: Next exercise if any left
        }

    }

    private func speak(text: String) {
        utterance = AVSpeechUtterance(string: text)
        utterance?.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance?.rate = 1.0

        if let utterance = utterance {
            synthesizer.delegate = self
            synthesizer.speak(utterance)
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("all done")
    }

}

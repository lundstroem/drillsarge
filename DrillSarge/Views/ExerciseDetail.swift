//
//  ExerciseDetail.swift
//  DrillSarge
//
//  Created by user on 2023-10-07.
//

import SwiftUI

struct ExerciseDetail: View {

    // stepper
    @State private var durationValue = 0
    @State private var name: String = ""

    @EnvironmentObject var modelData: ModelData
    var program: Program
    var programIndex: Int {
        modelData.programs.firstIndex(where: { $0.id == program.id })!
    }

    var exercise: Exercise
    var exerciseIndex: Int {
        modelData.programs[programIndex].exercises.firstIndex(where: { $0.id == exercise.id })!
    }

    var body: some View {
        VStack {
            TextField(
                exercise.name,
                    text: $name
                ).onSubmit {
                    //validate(name: username)
                }.border(.secondary)
            Stepper {
                //Text("Seconds: \(durationValue)")
                Text("Seconds: \(exercise.duration)")
            } onIncrement: {
                incrementStep()
            } onDecrement: {
                decrementStep()
            }
            Button("save", action: {
                modelData.programs[programIndex].exercises[exerciseIndex].name = name
                modelData.programs[programIndex].exercises[exerciseIndex].duration = durationValue
            })
        }.padding(20)
    }

    private func incrementStep() {
        durationValue += 15
    }

    private func decrementStep() {
        durationValue -= 15
        if durationValue < 15 { durationValue = 15 }
    }
}

struct ExerciseDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        ExerciseDetail(program:modelData.programs[0], exercise: modelData.programs[0].exercises[0] ).environmentObject(ModelData())
    }
}

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

    @Binding var exercise: Exercise

    var body: some View {
        NavigationStack {
            VStack {
                TextField(
                    exercise.name,
                    text: $exercise.name
                ).border(.secondary)
                Stepper {
                    Text("Seconds: \(exercise.duration)")
                } onIncrement: {
                    incrementStep()
                } onDecrement: {
                    decrementStep()
                }
            }.padding(20)
        }.navigationTitle(exercise.name)
    }

    private func incrementStep() {
        exercise.duration += 15
    }

    private func decrementStep() {
        exercise.duration -= 15
        if exercise.duration < 15 { exercise.duration = 15 }
    }
}

struct ExerciseDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        ExerciseDetail(exercise: .constant(.default))
    }
}

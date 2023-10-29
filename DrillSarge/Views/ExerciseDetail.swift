//
//  ExerciseDetail.swift
//  DrillSarge
//
//  Created by user on 2023-10-07.
//

import SwiftUI
import AVFoundation

struct ExerciseDetail: View {

    @Binding var exercise: Exercise

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        exercise.name,
                        text: $exercise.name
                    ).textFieldStyle(.plain)
                    Stepper {
                        Text("duration \(exercise.duration)s")
                    } onIncrement: {
                        incrementStep()
                    } onDecrement: {
                        decrementStep()
                    }
                }
            }.listRowSeparator(.hidden)
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

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
    @Binding var isDetailPresented: Bool

    @Environment(ModelData.self) private var modelData

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        exercise.name,
                        text: $exercise.name
                    ).textFieldStyle(.plain)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                    Stepper {
                        Text("duration \(exercise.duration)s")
                    } onIncrement: {
                        incrementStep()
                    } onDecrement: {
                        decrementStep()
                    }
                }
            }.listRowSeparator(.hidden).toolbar {

                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        isDetailPresented = false
                    }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        modelData.storeExercise(exercise: exercise)
                        isDetailPresented = false
                    }
                }
            }
        }

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
        ExerciseDetail(exercise: .constant(.default), isDetailPresented: .constant(false))
    }
}

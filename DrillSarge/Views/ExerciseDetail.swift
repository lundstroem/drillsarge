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
                        modelData.updateExercise(exercise: exercise)
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

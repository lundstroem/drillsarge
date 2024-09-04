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

struct ProgramDetailList: View {

    @Environment(ModelData.self) private var modelData

    @State private var isDetailPresented = false

    var program: Program
    private var programIndex: Int {
        modelData.persistentStorage.programs.firstIndex(where: { $0.id == program.id })!
    }

    @State private var defaultExercise = Exercise.default
    @State private var selectedExercise = Exercise.default

    private func exerciseIndex(exercise: Exercise) -> Int {
        modelData.persistentStorage.programs[programIndex].exercises.firstIndex(where: { $0.id == exercise.id })!
    }

    private func delete(at offsets: IndexSet) {
        modelData.persistentStorage.programs[programIndex].exercises.remove(atOffsets: offsets)
    }

    var body: some View {

        // Create binding to modelData so we can send in bindings to exercises
        // to ExerciseListItemView.
        @Bindable var modelDataBinding: ModelData = modelData

        NavigationStack {
            ZStack {
                List {
                    ForEach($modelDataBinding.persistentStorage.programs[programIndex].exercises) { exercise in
                        ExerciseListItemView(exercise: exercise,
                                             selectedExercise: $selectedExercise,
                                             isDetailPresented: $isDetailPresented)
                    }.onMove { from, to in
                        modelData.persistentStorage.programs[programIndex].exercises.move(fromOffsets: from, toOffset: to)
                    }.onDelete(perform: delete)
                }.sheet(isPresented: $isDetailPresented, content: {
                    ExerciseDetail(exercise: $selectedExercise, isDetailPresented: $isDetailPresented)
                }).toolbar {
                    makeToolbarContent()
                }
                VStack {
                    Text("\(modelData.programRunner.currentExerciseName)").font(.largeTitle).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    if modelData.programRunner.durationLeftSeconds > 0 {
                        Text("\(modelData.programRunner.durationLeftSeconds)").font(.largeTitle).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                    } else {
                        Text("-").font(.largeTitle).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                    }
                }.background(.green)
                    .cornerRadius(15)
                    .opacity(modelData.programRunner.isRunningProgram ? 1 : 0)
            }
        }.navigationTitle(modelData.persistentStorage.programs[programIndex].name)
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Button {
                modelData.programRunner.run(program: program)
                modelData.programRunner.isRunningProgram = true
            } label: {
                Label("play", systemImage: "play")
            }
            Spacer()
            Button {
                modelData.programRunner.stop()
            } label: {
                Label("stop", systemImage: "stop")
            }
            Spacer()
            Button {
                modelData.programRunner.run(program: program, shuffle: true)
            } label: {
                Label("shuffle", systemImage: "shuffle")
            }
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                modelData.persistentStorage.programs[programIndex].exercises.append(Exercise(name: "new exercise", duration: 15))
            } label: {
                Label("Add row", systemImage: "plus")
            }
        }
    }
}

struct ProgramDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        ProgramDetailList(program: modelData.persistentStorage.programs[0])
    }
}


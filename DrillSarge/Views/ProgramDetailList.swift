//
//  ProgramDetailList.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import SwiftUI

struct ProgramDetailList: View {

    @Environment(ModelData.self) private var modelData
    @Environment(ProgramRunner.self) private var programRunner

    @State private var isRunningProgram = false
    @State private var isDetailPresented = false

    var program: Program
    var programIndex: Int {
        modelData.programs.firstIndex(where: { $0.id == program.id })!
    }

    @State private var defaultExercise = Exercise.default
    @State private var selectedExercise = Exercise.default

    private func exerciseIndex(exercise: Exercise) -> Int {
        modelData.programs[programIndex].exercises.firstIndex(where: { $0.id == exercise.id })!
    }

    private func delete(at offsets: IndexSet) {
        modelData.programs[programIndex].exercises.remove(atOffsets: offsets)
    }

    var body: some View {

        // Create binding to modelData so we can send in bindings to exercises
        // to ExerciseListItemView.
        @Bindable var modelDataBinding: ModelData = modelData

        NavigationStack {
            ZStack {
                List {
                    ForEach($modelDataBinding.programs[programIndex].exercises) { exercise in
                        ExerciseListItemView(exercise: exercise,
                                             selectedExercise: $selectedExercise,
                                             isDetailPresented: $isDetailPresented)
                    }.onMove { from, to in
                        modelData.programs[programIndex].exercises.move(fromOffsets: from, toOffset: to)
                    }.onDelete(perform: delete)
                }.sheet(isPresented: $isDetailPresented, content: {
                    ExerciseDetail(exercise: $selectedExercise, isDetailPresented: $isDetailPresented)
                }).toolbar {
                    makeToolbarContent()
                }
                VStack {
                    Text("Running").font(.largeTitle).padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                    Text("\(programRunner.currentExerciseName)").font(.largeTitle).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    if programRunner.durationLeft > 0 {
                        Text("\(programRunner.durationLeft)").font(.largeTitle).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                    } else {
                        Text("-").font(.largeTitle).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                    }
                }.background(.green)
                    .cornerRadius(15)
                    .opacity(isRunningProgram ? 1 : 0)
            }
        }.navigationTitle(modelData.programs[programIndex].name)
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Button {
                programRunner.run(program: program)
                isRunningProgram = true
            } label: {
                Label("play", systemImage: "play")
            }
            Spacer()
            Button {
                programRunner.stop()
                isRunningProgram = false
            } label: {
                Label("stop", systemImage: "stop")
            }
            Spacer()
            Button {
                programRunner.run(program: program, shuffle: true)
            } label: {
                Label("shuffle", systemImage: "shuffle")
            }
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                modelData.programs[programIndex].exercises.append(Exercise(name: "new exercise", duration: 15))
            } label: {
                Label("Add row", systemImage: "plus")
            }
        }
    }
}

struct ProgramDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        ProgramDetailList(program: modelData.programs[0])
    }
}


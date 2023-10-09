//
//  ProgramDetailList.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import SwiftUI

struct ProgramDetailList: View {

    @EnvironmentObject var modelData: ModelData
    var program: Program
    var programIndex: Int {
        modelData.programs.firstIndex(where: { $0.id == program.id })!
    }

    @State private var defaultExercise = Exercise.default

    private func exerciseIndex(exercise: Exercise) -> Int {
        modelData.programs[programIndex].exercises.firstIndex(where: { $0.id == exercise.id })!
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(modelData.programs[programIndex].exercises) { exercise in
                    NavigationLink {

                        // Send in a binding to defaultExercise so
                        // ExerciseDetail gets read and write access
                        // to it

                        ExerciseDetail(exercise: $defaultExercise).onAppear {

                            // Update defaultExercise with the exercise
                            // from list

                            defaultExercise = exercise
                        }.onDisappear {

                            // Check if defaultExercise has been edited
                            // and differs from the one in modelData. If
                            // so, store the edited version in modelData
                            // and write to persistent storage

                            if modelData.programs[programIndex].exercises[exerciseIndex(exercise: exercise)] != defaultExercise {
                                modelData.programs[programIndex].exercises[exerciseIndex(exercise: exercise)] = defaultExercise
                                modelData.storeData()
                            }
                        }
                    } label: {
                        Text(exercise.name)
                    }
                }
            }.toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        ProgramRunner.run(program: program)
                    } label: {
                        Label("play", systemImage: "play")
                    }
                    Spacer()
                    Button {
                        ProgramRunner.stop()
                    } label: {
                        Label("stop", systemImage: "stop")
                    }
                    Spacer()
                    Button {
                        ProgramRunner.run(program: program, shuffle: true)
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
        }.navigationTitle(modelData.programs[programIndex].name)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        ProgramDetailList(program: modelData.programs[0]).environmentObject(modelData)
    }
}

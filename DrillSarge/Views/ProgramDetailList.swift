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
                        ExerciseDetail(exercise: $defaultExercise).onAppear {
                            defaultExercise = exercise
                        }.onDisappear {
                            modelData.programs[programIndex].exercises[exerciseIndex(exercise: exercise)] = defaultExercise
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
                        print("Stop")
                    } label: {
                        Label("shuffle", systemImage: "stop")
                    }
                    Spacer()
                    Button {
                        print("Shuffle")
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

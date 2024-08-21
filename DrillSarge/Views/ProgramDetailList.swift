//
//  ProgramDetailList.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import SwiftUI

struct ProgramDetailList: View {

    @State private var isRunningProgram = false
    
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var programRunner: ProgramRunner

    var program: Program
    var programIndex: Int {
        modelData.programs.firstIndex(where: { $0.id == program.id })!
    }

    @State private var defaultExercise = Exercise.default

    private func exerciseIndex(exercise: Exercise) -> Int {
        modelData.programs[programIndex].exercises.firstIndex(where: { $0.id == exercise.id })!
    }

    private func delete(at offsets: IndexSet) {
        modelData.programs[programIndex].exercises.remove(atOffsets: offsets)
    }

    var body: some View {
        NavigationStack {
            ZStack {
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
                    }.onMove { from, to in
                        modelData.programs[programIndex].exercises.move(fromOffsets: from, toOffset: to)
                    }.onDelete(perform: delete)
                }.toolbar {
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
}

struct ProgramDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        ProgramDetailList(program: modelData.programs[0]).environmentObject(modelData)
    }
}

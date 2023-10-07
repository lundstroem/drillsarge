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

    var body: some View {
        List {
            ForEach(modelData.programs[programIndex].exercises) { exercise in

                NavigationLink {
                    ExerciseDetail(program: program, exercise: exercise)
                } label: {
                    Text(exercise.name)
                }
            }
        }
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        ProgramDetailList(program: modelData.programs[0]).environmentObject(modelData)
    }
}

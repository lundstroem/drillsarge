//
//  ProgramList.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import SwiftUI

struct ProgramList: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        NavigationView {
            List {
                ForEach(modelData.programs) { program in
                    NavigationLink {
                        ProgramDetailList(program: program)
                    } label: {
                        Text(program.name)
                    }
                }.onMove { from, to in
                    modelData.programs.move(fromOffsets: from, toOffset: to)
                }
            }.toolbar {
                Button {
                    modelData.programs.append(Program(name: "New program"))
                } label: {
                    Label("Add row", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    ProgramList().environmentObject(ModelData())
}

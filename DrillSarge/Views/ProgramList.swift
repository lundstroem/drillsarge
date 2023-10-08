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
        NavigationStack {
            Text("DrillSarge")
                .bold()
                .font(.title)
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
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        modelData.programs.append(Program(name: "New program"))
                    } label: {
                        Label("Add row", systemImage: "plus")
                    }
                }
            }
        }.onAppear {
            // Load data if available
            modelData.loadData()
        }
    }
}

#Preview {
    ProgramList().environmentObject(ModelData())
}

//
//  ProgramList.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import SwiftUI

struct ProgramList: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var modelData: ModelData
    @State private var showingSettingsSheet = false

    private func delete(at offsets: IndexSet) {
        modelData.programs.remove(atOffsets: offsets)
    }

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
                }.onDelete(perform: delete)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        modelData.programs.append(Program(name: "New program"))
                    } label: {
                        Label("Add row", systemImage: "plus")
                    }
                }
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        showingSettingsSheet.toggle()
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .sheet(isPresented: $showingSettingsSheet) {
                        SettingsView()
                    }
                }
            }
        }.onAppear {
            // Load data if available
            modelData.loadData()
        }.onChange(of: scenePhase) {
            if scenePhase == .inactive || scenePhase == .background {
                modelData.storeData()
            }
        }
    }
}

#Preview {
    ProgramList().environmentObject(ModelData())
}

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

struct ProgramList: View {

    @Environment(\.scenePhase) var scenePhase
    @Environment(ModelData.self) private var modelData

    @State private var showingSettingsSheet = false

    private func delete(at offsets: IndexSet) {
        modelData.persistentStorage.programs.remove(atOffsets: offsets)
    }

    var body: some View {
        NavigationStack {
            Text("DrillSarge")
                .bold()
                .font(.title)
            List {
                ForEach(modelData.persistentStorage.programs) { program in
                    NavigationLink {
                        ProgramDetailList(program: program)
                    } label: {
                        Text(program.name)
                    }
                }.onMove { from, to in
                    modelData.persistentStorage.programs.move(fromOffsets: from, toOffset: to)
                }.onDelete(perform: delete)
            }
            .toolbar {
                makeToolbarContent()
            }
        }.onAppear {
            modelData.loadData()
        }.onChange(of: scenePhase) {
            if scenePhase == .inactive || scenePhase == .background {
                modelData.storeData()
            }
        }
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                modelData.persistentStorage.programs.append(Program(name: "New program"))
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
                SettingsView(modelData: modelData)
            }
        }
    }
}

#Preview {
    ProgramList()
}


//
//  ContentView.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        ProgramList()
    }
}

#Preview {
    ContentView().environmentObject(ModelData())
}

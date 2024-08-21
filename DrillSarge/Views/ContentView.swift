//
//  ContentView.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import SwiftUI

struct ContentView: View {
    @Environment(ModelData.self) private var modelData

    var body: some View {
        ProgramList()
    }
}


#Preview {
    ContentView()
}


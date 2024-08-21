//
//  DrillSargeApp.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import SwiftUI

@main
struct DrillSargeApp: App {

    /*

     TODO:
     - Cancel edit of program to not store changes

     */
    @State private var modelData = ModelData()
    @State private var programRunner = ProgramRunner()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(modelData).environment(programRunner)
        }
    }
}

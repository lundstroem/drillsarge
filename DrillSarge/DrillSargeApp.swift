//
//  DrillSargeApp.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import SwiftUI

@main
struct DrillSargeApp: App {

    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(modelData)
        }
    }
}

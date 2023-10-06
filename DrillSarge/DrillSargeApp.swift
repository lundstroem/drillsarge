//
//  DrillSargeApp.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import SwiftUI

@main
struct DrillSargeApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(modelData)
        }
    }
}

//
//  ModelData.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import Foundation

final class ModelData: ObservableObject {

    @Published var programs: [Program] = [Program(name: "mock program 1", exercises:
                                                    [Exercise(name: "mock exercise 1", duration: 30),
                                                     Exercise(name: "mock exercise 2", duration: 15),
                                                     Exercise(name: "mock exercise 3", duration: 15)]),
                                          Program(name: "mock program 2", exercises:
                                                    [Exercise(name: "mock exercise 4", duration: 30),
                                                     Exercise(name: "mock exercise 5", duration: 15),
                                                     Exercise(name: "mock exercise 6", duration: 15)])]

    func storeData() {
        let jsonEncoder = JSONEncoder()
        var jsonData: Data?
        do {
            jsonData = try jsonEncoder.encode(programs)
        } catch {
            print("Unexpected error: \(error).")
        }
        
        if let jsonData = jsonData {
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("jsonString:\(jsonString ?? "")")

            let defaults = UserDefaults.standard
            defaults.set(jsonString, forKey: "programs")
        }
    }

    func loadData() {
        let defaults = UserDefaults.standard

        if let jsonString: String = defaults.object(forKey: "programs") as? String {
            if let data = jsonString.data(using: .utf8) {
                let loadedPrograms: [Program] = try! JSONDecoder().decode([Program].self, from: data)
                print("loadedPrograms: \(loadedPrograms.count)")
                programs = loadedPrograms
            }
        }
    }
}

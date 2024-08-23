//
//  PersistentStorage.swift
//  DrillSarge
//
//  Created by user on 2024-08-23.
//

import Foundation

struct PersistentStorage: Hashable, Identifiable, Codable {
    var id = UUID()
    var voiceName: String?
    var programs: [Program] = [Program(name: "mock program 1", exercises:
                                        [Exercise(name: "mock exercise 1", duration: 30),
                                         Exercise(name: "mock exercise 2", duration: 15),
                                         Exercise(name: "mock exercise 3", duration: 15)]),
                               Program(name: "mock program 2", exercises:
                                        [Exercise(name: "mock exercise 4", duration: 30),
                                         Exercise(name: "mock exercise 5", duration: 15),
                                         Exercise(name: "mock exercise 6", duration: 15)])]

    enum CodingKeys: String, CodingKey {
        case voiceName = "voiceName"
        case programs = "programs"
    }
}

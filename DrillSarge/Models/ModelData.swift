//
//  ModelData.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    // TODO: DO some switch here between mock and real data. Best practices?
    //@Published var programs: [Program] = []
    @Published var programs: [Program] = [Program(name: "mock program 1", exercises:
                                                    [Exercise(name: "mock exercise 1", duration: 30),
                                                     Exercise(name: "mock exercise 2", duration: 15),
                                                     Exercise(name: "mock exercise 3", duration: 10)]),
                                          Program(name: "mock program 2", exercises:
                                                    [Exercise(name: "mock exercise 4", duration: 30),
                                                     Exercise(name: "mock exercise 5", duration: 15),
                                                     Exercise(name: "mock exercise 6", duration: 10)])]
}

//
//  ModelData.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var programs: [Program] = []
}

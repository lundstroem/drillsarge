//
//  Exercise.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import Foundation

struct Exercise: Hashable, Identifiable {

    static var `default` = Exercise(name: "name", duration: 15)

    let id = UUID()
    var name: String
    var duration: Int
}

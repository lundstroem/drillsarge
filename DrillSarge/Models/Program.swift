//
//  Program.swift
//  DrillSarge
//
//  Created by user on 2023-10-06.
//

import Foundation

struct Program: Hashable, Identifiable {
    let id = UUID()
    var name: String
    var exercises: [Exercise] = []
}

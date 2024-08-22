//
//  ExerciseListItemView.swift
//  DrillSarge
//
//  Created by user on 2024-08-22.
//

import SwiftUI

struct ExerciseListItemView: View {

    @Binding var exercise: Exercise
    @Binding var selectedExercise: Exercise
    @Binding var isDetailPresented: Bool

    @State private var didTap: Bool = false
    
    var body: some View {
        HStack {
            Text("\(exercise.name) \(exercise.duration)")
        }.onTapGesture {
            didTap = true
            selectedExercise = exercise
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { didTap = false }
            isDetailPresented.toggle()
        }
    }
}

#Preview {
    ExerciseListItemView(exercise: .constant(.default),
                         selectedExercise: .constant(.default),
                         isDetailPresented: .constant(false))
}

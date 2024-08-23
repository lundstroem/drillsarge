//
//  Voice.swift
//  DrillSarge
//
//  Created by Harry Lundström on 2023-10-29.
//

import Foundation
import AVFoundation

struct Voice: Identifiable, Hashable {
    var id = UUID()
    var speechVoice: AVSpeechSynthesisVoice

    enum CodingKeys: String, CodingKey {
        case speechVoice = "speechVoice"
    }
}

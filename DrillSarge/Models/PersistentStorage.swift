/*

 MIT License

 Copyright (c) 2024 Harry Lundström

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

import Foundation

struct PersistentStorage: Hashable, Identifiable, Codable {
    var id = UUID()
    var voiceName: String?
    var programs: [Program] = [Program(name: "program 1", exercises:
                                        [Exercise(name: "pushups", duration: 15),
                                         Exercise(name: "plank", duration: 60),
                                         Exercise(name: "squats", duration: 15)]),
                               Program(name: "program 2", exercises:
                                        [Exercise(name: "jumping jacks", duration: 30),
                                         Exercise(name: "right side plank", duration: 15),
                                         Exercise(name: "left side plank", duration: 15)])]

    enum CodingKeys: String, CodingKey {
        case voiceName = "voiceName"
        case programs = "programs"
    }
}

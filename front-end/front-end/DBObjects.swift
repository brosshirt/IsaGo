//
//  DBObjects.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/23/22.
//

import Foundation


class Class: Hashable, Codable, Identifiable{
    let class_name: String

    init(class_name: String) {
        self.class_name = class_name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(class_name)
    }

    static func == (lhs: Class, rhs: Class) -> Bool {
        return lhs.class_name == rhs.class_name
    }
}

class Lesson: Hashable, Codable{
    let class_name: String
    let lesson_name: String
    let lesson_date: String

    init(class_name: String, lesson_name: String, lesson_date: String) {
        self.class_name = class_name
        self.lesson_name = lesson_name
        self.lesson_date = lesson_date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(lesson_name)
    }

    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        return lhs.lesson_name == rhs.lesson_name && lhs.lesson_date == rhs.lesson_date
    }
}



// Declare a struct to represent a single checkbox
struct Checkbox: Identifiable {
    let id: UUID = UUID()
    let title: String
    var isChecked: Bool
}

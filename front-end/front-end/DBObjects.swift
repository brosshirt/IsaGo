//
//  DBObjects.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/23/22.
//

import Foundation


class Class: Hashable, Codable, Identifiable{
    let class_name: String
    let class_time: String

    init(class_name: String, class_time: String) {
        self.class_name = class_name
        self.class_time = class_time
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(class_name)
        hasher.combine(class_time)
    }
    static func == (lhs: Class, rhs: Class) -> Bool {
        return lhs.class_name == rhs.class_name && lhs.class_time == rhs.class_time
    }
}

class Lecture: Hashable, Codable{
    let class_name: String
    let lesson_name: String
    let lecture_date: String

    init(class_name: String, lesson_name: String, lecture_date: String) {
        self.class_name = class_name
        self.lesson_name = lesson_name
        self.lecture_date = lecture_date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(class_name)
        hasher.combine(lesson_name)
        hasher.combine(lecture_date)
    }

    static func == (lhs: Lecture, rhs: Lecture) -> Bool {
        return lhs.lesson_name == rhs.lesson_name && lhs.lecture_date == rhs.lecture_date && lhs.class_name == rhs.class_name
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
        hasher.combine(class_name)
        hasher.combine(lesson_name)
        hasher.combine(lesson_date)
    }

    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        return lhs.lesson_name == rhs.lesson_name && lhs.lesson_date == rhs.lesson_date && lhs.class_name == rhs.class_name
    }
}





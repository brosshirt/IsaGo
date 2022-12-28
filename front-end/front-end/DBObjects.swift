//
//  DBObjects.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/23/22.
//

import Foundation


class Class: Hashable, Codable{
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

// Declare a struct to represent a single checkbox
struct Checkbox: Identifiable {
    let id: UUID = UUID()
    let title: String
    var isChecked: Bool
}

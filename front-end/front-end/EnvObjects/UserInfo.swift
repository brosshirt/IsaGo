//
//  UserInfo.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/14/23.
//

import Foundation



// this is just a simplified version of the response to get /classes, it represents the data needed to display the first couple views
struct Classes {
    var taking: [Class]
    var notTaking: [Class]
    
    init(taking: [Class], notTaking: [Class]) {
        self.taking = taking
        self.notTaking = notTaking
    }
}



// this object contains all the necessary user information such that it can be accessed by any view without having to be passed around

// Any operation that modifies a state object must take place on the main thread. @MainActor is supposed to ensure this.
@MainActor class UserInfo: ObservableObject{
    @Published var classes: Classes = Classes(taking: [], notTaking: [])
    
    @Published var student_id: String = ""
    
    @MainActor func updateClasses(taking: [Class], notTaking: [Class]){
        self.classes.taking = taking
        self.classes.notTaking = notTaking
    }
    // just moves the class with className and classTime from taking into notTaking
        
    @MainActor func dropClass(className: String, classTime:String){
        for i in 0..<self.classes.taking.count {
            if (self.classes.taking[i].class_name == className && self.classes.taking[i].class_time == classTime){
                self.classes.notTaking.append(self.classes.taking.remove(at: i))
                break
            }
        }
    }
    
    @MainActor func addClass(className:String, classTime: String){
        for i in 0..<self.classes.notTaking.count {
            if (self.classes.notTaking[i].class_name == className && self.classes.notTaking[i].class_time == classTime){
                self.classes.taking.append(self.classes.notTaking.remove(at: i))
                break
            }
        }
    }
}




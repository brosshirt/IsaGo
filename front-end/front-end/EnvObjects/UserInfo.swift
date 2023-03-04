//
//  UserInfo.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/14/23.
//

import Foundation


// this object contains all the necessary user information such that it can be accessed by any view without having to be passed around

// ANY OPERATION THAT MODIFIES A STATE OBJECT MUST TAKE PLACE ON THE MAIN THREAD
// @MainActor is supposed to be a way of ensuring that all code takes place on the mainthread, but it's not removing all errors, so for now I'm just going to throw critical code in .main.async
class UserInfo: ObservableObject{
    
    static let instance = UserInfo()
    private init() {}
    
    @Published var classes: Classes = Classes(taking: [], notTaking: [])
    
    @Published var student_id: String = ""
    
    @Published var token: String = ""
    
    func updateClasses(taking: [Class], notTaking: [Class]){
        DispatchQueue.main.async{
            self.classes.taking = taking
            self.classes.notTaking = notTaking
        }
    }
    // just moves the class with className and classTime from taking into notTaking
    // I suppose it could be possible that it's actual more performant to throw the whole thing in main.async?? 
    func dropClass(className: String, classTime:String){
        for i in 0..<self.classes.taking.count {
            if (self.classes.taking[i].class_name == className && self.classes.taking[i].class_time == classTime){
                DispatchQueue.main.async{
                    self.classes.notTaking.append(self.classes.taking.remove(at: i))
                }
                break
            }
        }
    }
    
    func addClass(className:String, classTime: String){
        for i in 0..<self.classes.notTaking.count {
            if (self.classes.notTaking[i].class_name == className && self.classes.notTaking[i].class_time == classTime){
                DispatchQueue.main.async{
                    self.classes.taking.append(self.classes.notTaking.remove(at: i))
                }
                break
            }
        }
    }
}


// this is just a simplified version of the response to get /classes, it represents the data needed to display the first couple views
struct Classes {
    var taking: [Class]
    var notTaking: [Class]
    
    init(taking: [Class], notTaking: [Class]) {
        self.taking = taking
        self.notTaking = notTaking
    }
}




//
//  UserInfo.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/14/23.
//

import Foundation

// all the functions involving this object will take place on the main thread because of @MainActor (theoretically, it's not really working great)
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





//@MainActor class UserInfo: ObservableObject{
//    @Published var classes: Classes = Classes(taking: [], notTaking: [])
//
//    @Published var student_id: String = ""
//
//    func updateClasses(taking: [Class], notTaking: [Class], callback: @escaping () -> Void){
//        DispatchQueue.global().async {
//            self.classes.taking = taking
//            self.classes.notTaking = notTaking
//            DispatchQueue.main.sync {
//                self.objectWillChange.send()
//            }
//            callback()
//        }
//    }
//    // just moves the class with className and classTime from taking into notTaking
//    func dropClass(className: String, classTime: String){
//        DispatchQueue.global().async{
//            for i in 0..<self.classes.notTaking.count {
//                if (self.classes.notTaking[i].class_name == className && self.classes.notTaking[i].class_time == classTime){
//                    self.classes.taking.append(self.classes.notTaking.remove(at: i))
//                }
//            }
//            DispatchQueue.main.sync{
//                self.objectWillChange.send()
//            }
//        }
//    }
//
//    func addClass(className: String, classTime: String){
//        DispatchQueue.global().async{
//            for i in 0..<self.classes.taking.count {
//                if (self.classes.taking[i].class_name == className && self.classes.taking[i].class_time == classTime){
//                    self.classes.notTaking.append(self.classes.taking.remove(at: i))
//                }
//            }
//            DispatchQueue.main.sync{
//                self.objectWillChange.send()
//            }
//        }
//    }
//
//
//}

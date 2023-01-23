//
//  AddDrop.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI

import Darwin


struct AddDropView: View {
    @EnvironmentObject var userInfo:UserInfo
    
    @EnvironmentObject var router:Router
    
    @State var checkboxes: [Checkbox] = []
    
    @State var logout = false
    
    
    var body: some View {
        Text("Add and Drop Classes")
            .font(.largeTitle)
        List($checkboxes) { $checkbox in
            HStack {
                Toggle(isOn: $checkbox.isChecked){
                    HStack {
                        Text(checkbox.class_name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(timeString(class_time: checkbox.class_time))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }.onChange(of: checkbox.isChecked){ value in
                    let body = """
                    {
                        "class_name": "\(checkbox.class_name)",
                        "class_time": "\(checkbox.class_time)"
                    }
                    """
                    httpReq(method: value ? "POST" : "DELETE", body: body, route: "classes", as: EmptyResponse.self) { response in
                        if (value){
                            NotificationManager.instance.scheduleNotification(className: checkbox.class_name, classTime: checkbox.class_time)
                            userInfo.addClass(className: checkbox.class_name, classTime: checkbox.class_time)
                        }
                        else{
                            NotificationManager.instance.removeNotification(className: checkbox.class_name, classTime: checkbox.class_time)
                            userInfo.dropClass(className: checkbox.class_name, classTime: checkbox.class_time)
                        }
                    }
                }
            }
        }
        .onAppear {
            checkboxes = userInfo.classes.taking.map { my_class in
                Checkbox(class_name: my_class.class_name, class_time: my_class.class_time, isChecked: true)
            }
            checkboxes.append(contentsOf: userInfo.classes.notTaking.map { my_class in
                Checkbox(class_name: my_class.class_name, class_time: my_class.class_time, isChecked: false)
            })
         }
        Button(action: {
            httpReq(method: "DELETE", body: "", route: "account", as: EmptyResponse.self) { response in
                DispatchQueue.main.async{ // overkill but better safe than sorry
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    Cache.instance.removeAll()
                    userInfo.student_id = ""
                }
            }
        }, label: {
            Text("Delete your account")
                .font(.system(size: 22))
                .padding(10)
        })
    }
}


struct Checkbox: Identifiable {
    let id: UUID = UUID()
    let class_name: String
    let class_time: String
    var isChecked: Bool
}



//struct AddDrop_Previews: PreviewProvider {
//    static var previews: some View {
//        AddDrop()
//    }
//}

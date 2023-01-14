//
//  AddDrop.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI


struct AddDropView: View {
    // Declare a state variable to store the list of checkboxes
    @Binding var classes: Classes
    @State var checkboxes: [Checkbox] = []
    
    @State var homeScreen = false
    
    
    var body: some View {
        if (homeScreen){
            HomeView(classes: $classes)
        }
        else{
            Text("Add and Drop Classes")
                .font(.largeTitle)
            List($checkboxes) { $checkbox in
                HStack {
                    // Use a Toggle to create the checkbox
                    Toggle(isOn: $checkbox.isChecked){
//                        Text(checkbox.class_name)
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
                        httpReq(method: value ? "POST" : "DELETE", body: body, route: "classes") { response in
                            let res = getEmptyResponse(response: response)
                            if (res.status == 200){
                                if (value){
                                    NotificationManager.instance.scheduleNotification(className: checkbox.class_name, classTime: checkbox.class_time)
                                    // remove the item with checkbox.class_name from notTaking and move it into taking
                                    for i in 0..<classes.notTaking.count {
                                        if (classes.notTaking[i].class_name == checkbox.class_name && classes.notTaking[i].class_time == checkbox.class_time){
                                            classes.taking.append(classes.notTaking.remove(at: i))
                                            break
                                        }
                                    }
                                }
                                else{
                                    NotificationManager.instance.removeNotification(className: checkbox.class_name, classTime: checkbox.class_time)
                                    for i in 0..<classes.taking.count {
                                        if (classes.taking[i].class_name == checkbox.class_name && classes.taking[i].class_time == checkbox.class_time){
                                            classes.notTaking.append(classes.taking.remove(at: i))
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                checkboxes = classes.taking.map { my_class in
                    Checkbox(class_name: my_class.class_name, class_time: my_class.class_time, isChecked: true)
                }
                checkboxes.append(contentsOf: classes.notTaking.map { my_class in
                    Checkbox(class_name: my_class.class_name, class_time: my_class.class_time, isChecked: false)
                })
             }
        }
        
        
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

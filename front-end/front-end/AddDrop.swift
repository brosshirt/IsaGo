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
                .padding()
            List($checkboxes) { $checkbox in
                HStack {
                    // Use a Toggle to create the checkbox
                    Toggle(isOn: $checkbox.isChecked){
                        Text(checkbox.title)
                    }.onChange(of: checkbox.isChecked){ value in
                        let body = """
                        {
                            "name": "\(checkbox.title)"
                        }
                        """
                        httpReq(method: value ? "POST" : "DELETE", body: body, route: "class") { response in
                            let res = getEmptyResponse(response: response)
                            if (res.status == 200){
                                if (value){
                                    // remove the item with checkbox.title from notTaking and move it into taking
                                    for i in 0..<classes.notTaking.count {
                                        print("i is \(i)")
                                        if (classes.notTaking[i].class_name == checkbox.title){
                                            classes.taking.append(classes.notTaking.remove(at: i))
                                            break
                                        }
                                    }
                                    print("")
                                }
                                else{
                                    for i in 0..<classes.taking.count {
                                        print("i is \(i)")
                                        if (classes.taking[i].class_name == checkbox.title){
                                            classes.notTaking.append(classes.taking.remove(at: i))
                                            break
                                        }
                                    }
                                    print("")
                                }
                            }
                        }
                    }
                }
            }
            Button(action:{
                homeScreen = true
            }){
                Text("Back to home").foregroundColor(.blue)
            }
            .onAppear {
                checkboxes = classes.taking.map { my_class in
                    Checkbox(title: my_class.class_name, isChecked: true)
                }
                checkboxes.append(contentsOf: classes.notTaking.map { my_class in
                    Checkbox(title: my_class.class_name, isChecked: false)
                })
             }
        }
        
        
    }
}



//struct AddDrop_Previews: PreviewProvider {
//    static var previews: some View {
//        AddDrop()
//    }
//}

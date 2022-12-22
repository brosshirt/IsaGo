//
//  AddDrop.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI


let addDropURL = URL(string: "http://localhost/class")!

let availableURL = URL(string: "http://localhost/available")!






func getAddDropTask(name: String, add: Bool) -> URLSessionTask{
    let body = """
    {
        "name": "\(name)"
    }
    """
    
    var req = URLRequest(url: addDropURL)
    req.httpMethod = add ? "POST" : "DELETE"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.httpBody = body.data(using: .utf8)
    
    return URLSession.shared.uploadTask(with: req, from: nil){ data, response, error in
        if let error = error {
            print("Error \(error)")
            return
        }
        
        if let data = data, let response = String(data: data, encoding: .utf8){
            print("Response: \(response)")
        }
    }
}




struct AddDrop: View {
    // Declare a state variable to store the list of checkboxes
    @Binding var classes: [Class]
    
    
    @State var checkboxes: [Checkbox] = [
        Checkbox(title: "Option 1", isChecked: false),
        Checkbox(title: "Option 2", isChecked: false),
        Checkbox(title: "Option 3", isChecked: false)
    ]
    
    
    
    
    @State var homeScreen = false
    
    var body: some View {
        if (homeScreen){
            HomeView()
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
                        // So here we're going to want to send our fetch request with the title of the class
                        front_end.getAddDropTask(name: checkbox.title, add: value).resume()
                    }
                }
            }
            Button(action:{
                homeScreen = true
            }){
                Text("Back to home").foregroundColor(.blue)
            }
            .onAppear {
                
                checkboxes = classes.map { my_class in
                    Checkbox(title: my_class.class_name, isChecked: true)
                }
                
                var req = URLRequest(url: availableURL)
                req.httpMethod = "GET"
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")

                URLSession.shared.dataTask(with: req) {data, response, error in
                    do {
                        if let data = data, let response = String(data: data, encoding: .utf8){
                            let newData = response.data(using: .utf8)!
                            let res = try decoder.decode(ClassesResponse.self, from: newData)
                            print(res.classes)
                            let moreCheckboxes = res.classes.map { my_class in
                                Checkbox(title: my_class.class_name, isChecked:false)
                            }
                            checkboxes.append(contentsOf: moreCheckboxes)
                        }
                    }
                    catch {
                        print(error)
                    }

                }.resume()
             }
        }
        
        
    }
}

// Declare a struct to represent a single checkbox
struct Checkbox: Identifiable {
    let id: UUID = UUID()
    let title: String
    var isChecked: Bool
}

//struct AddDrop_Previews: PreviewProvider {
//    static var previews: some View {
//        AddDrop()
//    }
//}

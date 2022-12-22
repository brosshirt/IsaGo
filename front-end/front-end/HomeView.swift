//
//  HomeView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI
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

struct ClassesResponse: Codable {
    let status: Int
    let classes: [Class]
}

let decoder = JSONDecoder()


let classesURL = URL(string: "http://localhost/classes")!


struct HomeView: View {
    @State var selectClasses = false
    
    @State var classes: [Class] = []

    var body: some View {
        if (selectClasses){
            AddDrop(classes: $classes)
        }
        else{
            Text("My Classes")
                .font(.largeTitle)
                .padding()
            List(classes, id: \.self) { item in
                Text(item.class_name)
            }
            Button(action:{
                selectClasses = true
            }){
                Text("Add/Drop").foregroundColor(.blue)
            }
            .onAppear {
                var req = URLRequest(url: classesURL)
                req.httpMethod = "GET"
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.dataTask(with: req) {data, response, error in
                    do {
                        if let data = data, let response = String(data: data, encoding: .utf8){
                            let newData = response.data(using: .utf8)!
                            let res = try decoder.decode(ClassesResponse.self, from: newData)
                            classes = res.classes
                        }
                    }
                    catch {
                        print("my bad")
                    }
                    
                }.resume()
             }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

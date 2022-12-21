//
//  ContentView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI


let loginURL = URL(string: "http://localhost/login")!

func getLoginTask(name: String = "Titty Man") -> URLSessionTask{
    print("default name is \(name)")
    let body = """
    {
        "name": "\(name)"
    }
    """
    
    var req = URLRequest(url: loginURL)
    req.httpMethod = "POST"
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





struct ContentView: View {
    
    @State var homeview = false
    
    @State private var userID = ""
    @State private var dummy = ""
    
    var body: some View {
        if (homeview){
            HomeView()
        }
        else{
            Text("Login (Baby)")
                .font(.largeTitle)
                .padding()
            NavigationView{
                VStack{
                    Form{
                        Section(header: Text("Sign In")){
                            TextField("Username", text: $userID)
                            TextField("Dummy Field", text: $dummy)
                        }
                        Button(action: {
                            front_end.getLoginTask(name:userID).resume()
                            userID = ""
                        }) {
                            Text("Submit")
                        }
                    }
                    Button(action:{
                        homeview = true
                    }){
                        Text("Go to classes big dog")
                    }
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

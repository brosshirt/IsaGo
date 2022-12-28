//
//  ContentView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI


struct Classes {
    var taking: [Class]
    var notTaking: [Class]
    
    init(taking: [Class], notTaking: [Class]) {
        self.taking = taking
        self.notTaking = notTaking
    }
}




struct ContentView: View {
    
    @State var homeview = false
    
    @State private var userID = ""
    @State private var dummy = ""
    
    @State var classes: Classes = Classes(taking: [], notTaking: [])
    
    var body: some View {
        if (homeview){
            HomeView(classes: $classes)
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
                            let body = """
                            {
                                "name": "\(userID)"
                            }
                            """
                            httpReq(method: "POST", body: body, route: "login") { loginResponse in
                                let res = getEmptyResponse(response: loginResponse)
                                if (res.status == 200){
                                    userID = ""
                                    httpReq(method: "GET", body: "", route: "classes") { classesResponse in
                                        let res = getClassesResponse(response: classesResponse)
                                        classes.taking = res.taking
                                        classes.notTaking = res.notTaking
                                    }
                                }
                                
                            }
                            
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

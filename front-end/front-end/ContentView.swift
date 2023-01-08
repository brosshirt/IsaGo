//
//  ContentView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI
import Auth0


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
        
    @State var classes: Classes = Classes(taking: [], notTaking: [])
    
    var body: some View {
        if (homeview){
            HomeView(classes: $classes)
        }
        else{
            Button(action: {
                Auth0.webAuth().start{ result in
                    switch result{
                        case.failure(let error):
                            print(error)
                        
                        case.success(let credentials):
                            let profile = Profile.from(credentials.idToken)
                            print(profile.email.substring(start: 0, end: 6))
                            let body = """
                            {
                                "name": "\(profile.email.substring(start: 0, end: 6))"
                            }
                            """
                            httpReq(method: "POST", body: body, route: "login") { loginResponse in
                                let res = getEmptyResponse(response: loginResponse)
                                if (res.status == 200){
                                    httpReq(method: "GET", body: "", route: "classes") { classesResponse in
                                        let res = getClassesResponse(response: classesResponse)
                                        classes.taking = res.taking
                                        classes.notTaking = res.notTaking
                                        homeview = true
                                    }
                                }
                            }
                        
                    }
                }
            }) {
                Text("Log in")
            }
        }

    
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

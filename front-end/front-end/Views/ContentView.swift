//
//  ContentView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI
import Auth0

// this is just a simplified version of the response to get /classes, it represents the data needed to display the first couple views
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
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var userInfo:UserInfo

    
    var body: some View {
        if (homeview){
            HomeView()
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
                                        userInfo.updateClasses(taking: res.taking, notTaking: res.notTaking)
                                        homeview = true
                                    }
                                }
                            }
                        
                    }
                }
            }) {
                VStack{
                    if colorScheme == .dark {
                            Image("isago_hat")
                                .resizable()
                                .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: 60)
                                .colorInvert()
                        } else {
                            Image("isago_hat")
                                .resizable()
                                .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: 60)
                        }
                    Text("Login")
                }
                .onAppear{
                    NotificationManager.instance.requestAuthorization()
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

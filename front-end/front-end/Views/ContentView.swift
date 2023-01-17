//
//  ContentView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI
import Auth0



struct ContentView: View {
    
    @State var homeview = false
    
    @Environment(\.colorScheme) var colorScheme // dark mode
    
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
                            let body = """
                            {
                                "name": "\(profile.email.substring(start: 0, end: 6))"
                            }
                            """ // I know this way of defining objects seems really stupid but after looking at the alternatives its not so bad
                            httpReq(method: "POST", body: body, route: "login", as: EmptyResponse.self){ loginResponse in
                                httpReq(method: "GET", body: "", route: "classes", as: ClassesResponse.self){ classesResponse in
                                    userInfo.updateClasses(taking: classesResponse.taking, notTaking: classesResponse.notTaking)
                                    homeview = true
                                }
                            }
                        
                        
                        
//                            httpReq(method: "POST", body: body, route: "login") { loginResponse in
//                                let res = getEmptyResponse(response: loginResponse)
//                                if parseResponse(response: loginResponse, as: EmptyResponse.self) != nil {
//                                    httpReq(method: "GET", body: "", route: "classes") { classesResponse in
//                                        let res = getClassesResponse(response: classesResponse)
//                                        userInfo.updateClasses(taking: res.taking, notTaking: res.notTaking)
//                                        homeview = true
//                                    }
//                                } else if let res = parseResponse(response: loginResponse, as: ErrorResponse.self) {
//                                    print(res.msg) // this should be printed to the user probably
//                                } else {
//                                    print("Idek man the backend is sending me some nonsense")
//                                }
//
//                            }
                        
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

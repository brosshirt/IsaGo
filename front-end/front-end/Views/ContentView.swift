//
//  ContentView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI
import Auth0

import JWTDecode

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
                        case.failure(let error): // if the auth fails, idk why it would, just sign in again?
                            print(error)
                        case.success(let credentials):
                            print(credentials.idToken)
                            guard
                                let jwt = try? decode(jwt: credentials.idToken),
                                let email = jwt.claim(name: "email").string
                            else{
                                print("There's an error interpreting the result of the apple/google sign in")
                                return
                            }
                            print(email)
                            let body = """
                            {
                                "name": "\(email.substring(start: 0, end: 6))"
                            }
                            """ // I know this way of defining objects seems really stupid but after looking at the alternatives its not so bad
                            httpReq(method: "POST", body: body, route: "account", as: EmptyResponse.self){ loginResponse in
                                httpReq(method: "GET", body: "", route: "classes", as: ClassesResponse.self){ classesResponse in
                                    userInfo.updateClasses(taking: classesResponse.taking, notTaking: classesResponse.notTaking)
                                    homeview = true
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

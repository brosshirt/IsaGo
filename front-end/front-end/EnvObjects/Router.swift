//
//  Router.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/5/23.
//

import SwiftUI
// Object that controls your navigation
class Router: ObservableObject{
    // Once I get more comfortable with this I'd like to be able to manipulate the path however I want, it's just a list of... views? (I guess)
    @Published var path = NavigationPath()
    // takes you back to the homeView
    func reset(){
        path = NavigationPath()
    }
}

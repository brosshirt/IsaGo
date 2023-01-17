//
//  Router.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/5/23.
//

import SwiftUI

class Router: ObservableObject{
    @Published var path = NavigationPath()
    
    func reset(){
        path = NavigationPath()
    }
}

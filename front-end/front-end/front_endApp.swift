//
//  front_endApp.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI

@main
struct front_endApp: App {
    @StateObject var router = Router()
    @StateObject var hasLoaded = HasLoaded()
    @StateObject var userInfo = UserInfo()
    @StateObject var cache = Cache.instance
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(hasLoaded)
                .environmentObject(userInfo)
                .environmentObject(cache)
        }
    }
}

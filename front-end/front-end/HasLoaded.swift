//
//  HasLoaded.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/14/23.
//

import Foundation

// ok for now all this does is tell you whether the homeview has loaded
// if we want to make this more sophsticated this object should be a key value store between the views and boolean values indicating whether that view has loaded
class HasLoaded: ObservableObject{
    @Published var hasLoaded = false
}

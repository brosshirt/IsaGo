//
//  FeedBackView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/4/23.
//

import SwiftUI

struct FeedBackView: View {
    @Binding var lessonInfo: String
    
    var body: some View {
        Text(lessonInfo)
    }
}

//struct FeedBackView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedBackView()
//    }
//}

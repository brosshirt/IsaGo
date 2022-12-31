//
//  LessonView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/30/22.
//

import SwiftUI

struct LessonView: View {
    @Binding var lessonName: String
    
    var body: some View {
        Text("This is where the " + lessonName + " lesson will be")
    }
}

//struct LessonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LessonView()
//    }
//}

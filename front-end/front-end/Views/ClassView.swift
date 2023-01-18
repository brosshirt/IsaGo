//
//  ClassView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/30/22.
//

import SwiftUI


import Foundation


struct ClassView: View {
    @Binding var myClass: Class // the class being viewed
    
    @State var lectures: [Lecture] = [] // the lectures for the class
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        Text(myClass.class_name)
            .font(.largeTitle)
        List(lectures, id: \.self) { item in
            NavigationLink(value: item){
                HStack {
                    Text(item.lesson_name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(item.lecture_date.substring(start: 5, end: 10))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .navigationDestination(for: Lecture.self) { lecture in
            LessonView(lesson: .constant(lecture))
        }
        .onAppear{
            httpReq(method: "GET", body: "", route: "classes/\(myClass.class_name)/\(myClass.class_time)", as: LecturesResponse.self) { lecturesResponse in
                lectures = lecturesResponse.lectures
            }
        }
    }
}

//struct ClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassView(lessons: .constant(lessons))
//    }
//}

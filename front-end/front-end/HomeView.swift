//
//  HomeView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI
import Foundation




let decoder = JSONDecoder()




struct HomeView: View {
    @State var selectClasses = false
    @State var lessons: [Lesson] = []
    @State var class_name: String = ""
    
    @Binding var classes: Classes

    var body: some View {
        if (selectClasses){
            AddDropView(classes: $classes)
        }
        else if (lessons != []){
            ClassView(lessons: .constant(lessons), class_name: $class_name, classes: $classes)
        }
        else{
            Text("My Classes")
                .font(.largeTitle)
                .padding()
            List(classes.taking, id: \.self) { item in
                Text(item.class_name)
                    .onTapGesture {
                        print(item.class_name)
                        httpReq(method: "GET", body: "", route: item.class_name) { lessonsResponse in
                            let res = getLessonsResponse(response: lessonsResponse)
                            // you need to load a class view
                            class_name = item.class_name
                            lessons = res.lessons
//                            lessons = [Lesson(lesson_name: "Friendship", lesson_date: "12-26"),
//                                                                       Lesson(lesson_name: "Kindness", lesson_date: "12-27"),
//                                                                       Lesson(lesson_name: "Honesty", lesson_date: "12-28")]
                            return 
                        }
                    }
            }
            Button(action:{
                selectClasses = true
            }){
                Text("Add/Drop").foregroundColor(.blue)
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

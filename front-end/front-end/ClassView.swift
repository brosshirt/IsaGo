//
//  ClassView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/30/22.
//

import SwiftUI


import Foundation


struct ClassView: View {
    @Binding var class_name: String
    
    @State var lessons: [Lesson] = []
    
    @EnvironmentObject var router: Router
    
    
    @State var homeView = false;
    
    var body: some View {
        
            
        Text(class_name)
            .font(.largeTitle)
        List(lessons, id: \.self) { item in
            NavigationLink(value: item){
                HStack {
                    Text(item.lesson_name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(item.lesson_date.substring(start: 5, end: 10))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .navigationDestination(for: Lesson.self) { lesson in
            LessonView(lesson: .constant(lesson))
        }
        .navigationBarItems(trailing:
            Button(action: {
                router.reset()
            }) {
                Text("Classes")
            })
        .onAppear{
            httpReq(method: "GET", body: "", route: "classes/" + class_name) { lessonsResponse in
                let res = getLessonsResponse(response: lessonsResponse)
                lessons = res.lessons
            }
        }
        
            
        
    }
}






//struct ClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassView(lessons: .constant(lessons))
//    }
//}

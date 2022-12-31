//
//  ClassView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/30/22.
//

import SwiftUI


import Foundation


struct ClassView: View {
    @Binding var lessons: [Lesson]
    @Binding var class_name: String
    @Binding var classes: Classes
    
    @State var homeView = false;
    @State var lesson = ""
    
    
    var body: some View {
        if (homeView){
            HomeView(classes: $classes)
        }
        else if (lesson != ""){
            LessonView(lessonName: $lesson)
        }
        else{
            Text(class_name)
                .font(.largeTitle)
                .padding()
            List(lessons, id: \.self) { item in
                HStack {
                    Text(item.lesson_name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(item.lesson_date.substring(start: 5, end: 10))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }.onTapGesture {
                    lesson = item.lesson_name
                }
            }
            Button(action:{
                homeView = true
            }){
                Text("Back to home").foregroundColor(.blue)
            }
        }
        
    }
}






//struct ClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassView(lessons: .constant(lessons))
//    }
//}

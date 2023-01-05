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
    
    @EnvironmentObject var router:Router
    
    @Binding var classes: Classes

    var body: some View {
        if (selectClasses){
            AddDropView(classes: $classes)
        }
        else{
            NavigationStack (path: $router.path){
                Text("My Classes")
                    .font(.largeTitle)
                List(classes.taking, id: \.self){ item in
                    NavigationLink(item.class_name, value: item)
                }
                .navigationDestination(for: Class.self) { my_class in
                    ClassView(class_name: .constant(my_class.class_name))
                }
                NavigationLink(destination: AddDropView(classes: $classes)) {
                    Text("Add/Drop")
                        .font(.system(size: 22))
                        .padding(10)
                }
                .navigationBarItems(trailing:
                    NavigationLink(destination: FeedbackView(classes: $classes.taking)) {
                            Text("Give Feedback")
                        })
            }
            
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

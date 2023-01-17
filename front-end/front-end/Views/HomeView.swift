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
    @State var lessons: [Lesson] = []
    @State var class_name: String = ""
    
    @EnvironmentObject var router:Router
    @EnvironmentObject var hasLoaded:HasLoaded
    @EnvironmentObject var userInfo:UserInfo

    var body: some View {
        NavigationStack (path: $router.path){
            Text("My Classes")
                .font(.largeTitle)
            List(userInfo.classes.taking, id: \.self){ item in
                NavigationLink(value: item){
                    HStack {
                            Text(item.class_name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(timeString(class_time: item.class_time))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                }
            }
            .navigationDestination(for: Class.self) { my_class in
                ClassView(myClass: .constant(my_class))
            }
            NavigationLink(destination: AddDropView()) {
                Text("Add/Drop")
                    .font(.system(size: 22))
                    .padding(10)
            }
            .navigationBarItems(trailing:
                NavigationLink(destination: FeedbackView(selectedClass: "None", selectedLesson: "None")) {
                    Text("Give Feedback")
                }
            )
            .onAppear{
                print(userInfo.classes.taking)
                if !hasLoaded.hasLoaded{
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    for myClass in userInfo.classes.taking{
                        NotificationManager.instance.scheduleNotification(className: myClass.class_name, classTime: myClass.class_time)
                    }
                    hasLoaded.hasLoaded = true
                }
            }
        }
        
    }
}

func removeDuplicateClasses(classes: [Class]) -> [Class]{
    var output: [Class] = []
    for section in classes{
        var addSection = true
        for myClass in output{
            if (myClass.class_name == section.class_name){
                addSection = false
            }
        }
        if (addSection){
            output.append(section)
        }
    }
    return output
}



//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

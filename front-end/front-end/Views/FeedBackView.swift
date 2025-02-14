//
//  FeedBackView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/4/23.
//

import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var userInfo:UserInfo
        
    @State var feedback = ""
    @State var lessons: [Lesson] = [] // gets filled when a user has selected a class
    
    @State var selectedClass: String // either initialized to "None" or the name of the class
    @State var selectedLesson: String
    
    @State var submitted = false;

    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Class and Lesson Information")){
                    Picker(
                        selection: $selectedClass,
                        label:
                            HStack{
                                Text("Class in reference to: ")
                            },
                        content: {
                            Text("None").tag("None")
                            ForEach(removeDuplicateClasses(classes: userInfo.classes.taking), id: \.self) { myClass in
                                Text(myClass.class_name).tag(myClass.class_name)
                            }
                        }
                    ).onChange(of: selectedClass) { value in
                        selectedLesson = "None"
                        if value != "None" {
                            httpReq(method: "GET", body: "", route: "classes/\(selectedClass)", as: LessonsResponse.self) { lessonsResponse in
                                lessons = lessonsResponse.lessons
                            }
                        }
                    }
                    if lessons != [] {
                        Picker(
                            selection: $selectedLesson,
                            label:
                                HStack{
                                    Text("Lesson in reference to: ")
                                },
                            content: {
                                Text("None").tag("None")
                                ForEach(lessons, id: \.self) { lesson in
                                    Text(lesson.lesson_name).tag(lesson.lesson_name)
                                }
                            }
                        )
                    }
                }
                Section(header: Text("Feedback")){
                    TextField("Write your feedback here", text: $feedback, axis: .vertical)
                        .frame(maxHeight: 250)
                }
                Button(action: {
                    submitFeedback(selectedClass: selectedClass, selectedLesson: selectedLesson, feedback: feedback)
                    selectedClass = "None"
                    selectedLesson = "None"
                    feedback = ""
                    lessons = []
                    submitted = true
                }, label: {
                    Text("Submit Feedback")
                })
            }
            .navigationTitle("Feedback")
            .onAppear{
                if selectedClass != "None" { // if you come from the lessonView then selectedClass will be autofilled
                    httpReq(method: "GET", body: "", route: "classes/\(selectedClass)", as: LessonsResponse.self) { lessonsResponse in
                        lessons = lessonsResponse.lessons
                    }
                }
            }
        }
        if (submitted){
            ZStack {
                Spacer()
                Text("Submitted ✔️")
                    .font(.footnote)
                    .foregroundColor(.green)
                    .opacity(0.7)
                    .padding()
            }
//            .opacity(submitted ? 1 : 0) // invisible when submitted is false
        }
        
    }
}

func submitFeedback(selectedClass: String, selectedLesson: String, feedback: String){
    let escapedFeedback = feedback
        .replacingOccurrences(of: "\\", with: "\\\\") // escape backslashes
        .replacingOccurrences(of: "\n", with: "\\n") // escape newline characters
        .replacingOccurrences(of: "\t", with: "\\t") // escape tab characters
        .replacingOccurrences(of: "\r", with: "\\r") // escape carriage return characters
        .replacingOccurrences(of: "\"", with: "\\\"") // escape double quote characters
    
    let body = """
    {
        "class_name": "\(selectedClass)",
        "lesson_name": "\(selectedLesson)",
        "feedback": "\(escapedFeedback)"
    }
    """
    print(body)
    httpReq(method: "POST", body: body, route: "feedback", as: EmptyResponse.self) { emptyResponse in } // no need to do anything w res
}

//struct FeedbackView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        FeedbackView(classes: .constant([Class(class_name: "Mech 83"), Class(class_name: "Sex 109"), Class(class_name: "Jizz 22")]))
//    }
//}

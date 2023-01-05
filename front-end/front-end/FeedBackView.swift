//
//  FeedBackView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/4/23.
//

import SwiftUI

struct FeedbackView: View {
    @Binding var classes: [Class]
    
    @State var feedback = ""

    @State var lessons: [Lesson] = []
    
    @State var submitted = false;
    
    @State private var selectedClass: String = "None"
    @State private var selectedLesson: String = "None"

    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Class and Lesson Information")){
                    Picker(
                        selection: $selectedClass,
                        label:
                            HStack{
                                Text("Class in reference to: ")
                            }
                        ,
                        content: {
                            Text("None").tag("None")
                            ForEach(classes, id: \.self) { myClass in
                                Text(myClass.class_name).tag(myClass.class_name)
                            }
                        }
                    ).onChange(of: selectedClass) { value in
                        if value != "None" {
                            httpReq(method: "GET", body: "", route: "classes/" + selectedClass) { lessonsResponse in
                                let res = getLessonsResponse(response: lessonsResponse)
                                lessons = res.lessons
                            }
                        }
                    }
                    if lessons != [] {
                        Picker(
                            selection: $selectedLesson,
                            label:
                                HStack{
                                    Text("Lesson in reference to: ")
                                }
                            ,
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
                    submitted = true
                }, label: {
                    Text("Submit Feedback")
                })
            }
            .navigationTitle("Feedback")
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
            .opacity(submitted ? 1 : 0)
        }
        
    }
}

func submitFeedback(selectedClass: String, selectedLesson: String, feedback: String){
    let body = """
    {
        "class_name": "\(selectedClass)",
        "lesson_name": "\(selectedLesson)",
        "feedback": "\(feedback)"
    }
    """
    httpReq(method: "POST", body: body, route: "feedback") { emptyResponse in
        let res = getEmptyResponse(response: emptyResponse)
        if (res.status != 200){
            print("We've got a problem")
        }
    }
}


//struct FeedbackView: View {
//    @Binding var classes: [Class]
//
//    @State var feedback: String = ""
//
//
//    @State var lessons: [String] = ["lesson1", "lesson2", "lesson3", "lesson4"]
//
//
//    @State private var selectedClass: String = "None"
//    @State private var selectedLesson: String = "None"
//
//    var body: some View {
//        Text("Feedback")
//            .font(.largeTitle)
//        Spacer()
//        VStack {
//            VStack(alignment: .leading){
//                HStack{
//                    Text("Class this in reference to:")
//                    Picker(
//                        selection: $selectedClass,
//                        label:
//                            Text(selectedClass)
//                        ,
//                        content: {
//                            Text("None").tag("None")
//                            ForEach(classes, id: \.self) { myClass in
//                                    Text(myClass.class_name).tag(myClass.class_name)
//                            }
//                        }
//                    )
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                if selectedClass != "None" {
//                    HStack{
//                        Text("Lesson this in reference to:")
//                        Picker(
//                            selection: $selectedLesson,
//                            label:
//                                Text(selectedLesson)
//                            ,
//                            content: {
//                                Text("None").tag("None")
//                                ForEach(lessons, id: \.self) { lesson in
//                                        Text(lesson).tag(lesson)
//                                }
//                            }
//                        )
//                    }
//                }
//            }
//            .padding(.all)
//            Spacer()
//            VStack(alignment: .leading) {
//                Text("Feedback:")
//                TextField("Write your feedback here", text: $feedback)
//                    .padding(.horizontal, 8)
//                    .border(Color.gray.opacity(0.5), width: 1)
//                    .frame(minHeight: 50)
//            }
//            Spacer()
//            Spacer()
//
//        }
//        Spacer()
//        Button("Send feedback") {
//            // send feedback here
//        }
//    }
//}


struct FeedbackView_Previews: PreviewProvider {
    
    static var previews: some View {
        FeedbackView(classes: .constant([Class(class_name: "Mech 83"), Class(class_name: "Sex 109"), Class(class_name: "Jizz 22")]))
    }
}

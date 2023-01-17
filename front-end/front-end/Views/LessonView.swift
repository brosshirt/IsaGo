//
//  LessonView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/30/22.
//

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    @Binding var screenWidth: Double
    @Binding var pdfDocument: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        

        guard let page = pdfView.document?.page(at: 0) else { return pdfView }
        let pdfWidth = (page.bounds(for: .mediaBox).size.width)

        let scaleFactor = (0.98 * screenWidth) / pdfWidth

        pdfView.scaleFactor = scaleFactor
        pdfView.minScaleFactor = scaleFactor

        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        // Update the PDF view if needed
    }
}


struct LessonView: View {
    @EnvironmentObject var router: Router
    @Binding var lesson: Lecture

    @State var pdfDocument = PDFDocument()
    @State var isLoading = true

    var body: some View {
        if isLoading{
            Loader()
                .onAppear{
                    let url = URL(string: s3Url(class_name: lesson.class_name, lesson_name: lesson.lesson_name))!
                    print("On page load")
                    printTime()
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data, error == nil {
                            print("Pdf acquired")
                            printTime()
                            pdfDocument = PDFDocument(data: data)!
                            isLoading = false
                            print("isLoading: \(isLoading)")
                        } else {
                            print("Error fetching pdf data: \(error!)")
                        }
                    }
                    task.resume()
                }
        }
        else{
            GeometryReader{ geometry in
                PDFViewer(screenWidth: .constant(Double(geometry.size.width)), pdfDocument: $pdfDocument)
                    .navigationBarItems(trailing:
                        NavigationLink(destination: FeedbackView(selectedClass: lesson.class_name, selectedLesson: lesson.lesson_name)) {
                            Text("Give Feedback")
                        })
            }
            .id(pdfDocument) // this causes the view to rerender whenever this field changes
        }
    }
}

func printTime() {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let currentTime = dateFormatter.string(from: date)
    print("Current Time: \(currentTime)")
}

func s3Url(class_name:String, lesson_name: String) -> String {
    return sanitizeRoute(route: "https://s3.amazonaws.com/isago-lessons/\(class_name)/\(lesson_name).pdf")
}

//struct LessonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LessonView()
//    }
//}

//
//  LessonView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/30/22.
//

import SwiftUI
import PDFKit

let url = URL(fileURLWithPath: "/Users/benjaminrosshirt/Downloads/lesson.pdf")

func getPDF(lesson: Lesson) -> Data{
    var pdfData = Data()

    let group = DispatchGroup()
    group.enter()
    
    
    httpReq(method: "GET", body: "", route: "classes/\(lesson.class_name)/\(lesson.lesson_name)") { lessonResponse in
        let res = getLessonResponse(response: lessonResponse)
        if (res.status == 200){
            pdfData = Data(base64Encoded: res.lesson)!
        }
        group.leave()
    }
    group.wait()
    return pdfData
    
}
//
//
//
struct PDFViewer: UIViewRepresentable {
    @Binding var screenWidth: Double
    @Binding var lesson: Lesson

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: getPDF(lesson: lesson))

        let page = pdfView.document?.page(at: 0)
        let pdfWidth = (page?.bounds(for: .mediaBox).size.width)!

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
    @Binding var lesson: Lesson
    
    var body: some View {
        GeometryReader{ geometry in
            PDFViewer(screenWidth: .constant(Double(geometry.size.width)), lesson: $lesson)
                .navigationBarItems(trailing:
                NavigationLink("Give feedback", value: String(lesson.lesson_name + " " + lesson.class_name)))
                .navigationDestination(for: String.self) { lessonInfo in
                    FeedBackView(lessonInfo: .constant(lessonInfo))
                }
        }
        
    }
}

//struct LessonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LessonView()
//    }
//}

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

    
    
    
    httpReq(method: "GET", body: "", route: "classes/\(lesson.class_name)/\(lesson.lesson_name)") { lessonResponse in
        let res = getLessonResponse(response: lessonResponse)
        if (res.status == 200){
            pdfData = Data(base64Encoded: res.lesson)!
        }
    }
    return pdfData
    
}
//
//
//
struct PDFViewer: UIViewRepresentable {
    @Binding var screenWidth: Double
    @Binding var pdfDocument: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        print("This code only runs once")
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
    @Binding var lesson: Lesson
    
    @State var pdfDocument = PDFDocument()
    
    var body: some View {
        GeometryReader{ geometry in
            PDFViewer(screenWidth: .constant(Double(geometry.size.width)), pdfDocument: $pdfDocument)
                .navigationBarItems(trailing:
                    Button(action: {
                        router.reset()
                    }) {
                        Text("Classes")
                    })
        }
        .id(pdfDocument) // this causes the view to rerender whenever this field changes
        .onAppear{
            httpReq(method: "GET", body: "", route: "classes/\(lesson.class_name)/\(lesson.lesson_name)") { lessonResponse in
                let res = getLessonResponse(response: lessonResponse)
                if (res.status == 200){
                    let pdfData = Data(base64Encoded: res.lesson)!
                    pdfDocument = PDFDocument(data: pdfData)!
                }
            }
        }
    }
}

//struct LessonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LessonView()
//    }
//}

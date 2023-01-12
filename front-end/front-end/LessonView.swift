//
//  LessonView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/30/22.
//

import SwiftUI
import PDFKit

let url = URL(fileURLWithPath: "/Users/benjaminrosshirt/Downloads/lesson.pdf")
//
//
//
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
            let url = URL(string: s3Url(class_name: lesson.class_name, lesson_name: lesson.lesson_name))!
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, error == nil {
                    pdfDocument = PDFDocument(data: data)!
                } else {
                    print("Error fetching pdf data: \(error!)")
                }
            }
            task.resume()
        }
    }
}

func s3Url(class_name:String, lesson_name: String) -> String {
    return sanitizeRoute(route: "https://s3.amazonaws.com/isago-lessons/\(class_name)/\(lesson_name).pdf")
}

//struct LessonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LessonView()
//    }
//}

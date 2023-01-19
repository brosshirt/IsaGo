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
    
    // you can return views from functions that's cool
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        
        guard let page = pdfView.document?.page(at: 0) else { return pdfView } // get the first page
        let pdfWidth = (page.bounds(for: .mediaBox).size.width) // get the width of the first page of the pdf

        let scaleFactor = (0.98 * screenWidth) / pdfWidth // adjust the zoom level such that the pdf is perfectly placed in the screen

        pdfView.scaleFactor = scaleFactor
        pdfView.minScaleFactor = scaleFactor

        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) { // necessary for PDFViewer to conform
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
                    getPDF(className: lesson.class_name, lessonName: lesson.lesson_name) { data in
                        pdfDocument = PDFDocument(data: data)!
                        isLoading = false
                    }
                }
        }
        else{
            GeometryReader{ geometry in // used to get dimensions of a view
                PDFViewer(screenWidth: .constant(Double(geometry.size.width)), pdfDocument: $pdfDocument)
                    .navigationBarItems(trailing:
                        NavigationLink(destination: FeedbackView(selectedClass: lesson.class_name, selectedLesson: lesson.lesson_name)) {
                            Text("Give Feedback")
                        })
            }
            .id(pdfDocument) // this causes the view to rerender whenever this field changes, not sure it's necessary anymore
        }
    }
}


//struct LessonView_Previews: PreviewProvider {
//    static var previews: some View {
//        LessonView()
//    }
//}

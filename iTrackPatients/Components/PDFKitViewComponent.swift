//
//  PDFKitView.swift
//  iTrackPatients
//
//  Created by Guren Icim on 10.01.2024.
//

import Foundation
import PDFKit
import SwiftUI

struct PDFKitViewComponent: UIViewRepresentable {
    let url: URL // new variable to get the URL of the document
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitViewComponent>) -> PDFView {
        // Creating a new PDFVIew and adding a document to it
        let pdfView = PDFView()
        let urlx = url.standardizedFileURL
        do {
            let data = try Data(contentsOf: urlx)
            pdfView.document = PDFDocument(data: data)
        } catch{
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitViewComponent>) {
        // we will leave this empty as we don't need to update the PDF
    }
}

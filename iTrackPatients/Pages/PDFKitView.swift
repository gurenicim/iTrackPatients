//
//  PDFKitView.swift
//  iTrackPatients
//
//  Created by Guren Icim on 10.01.2024.
//

import SwiftUI

struct PDFKitView: View {
    var pdfUrl: URL
    var body: some View {
        NavigationStack {
            PDFKitViewComponent(url: pdfUrl)
                .scaledToFill()
        }.ignoresSafeArea(edges: .all)
    }
}


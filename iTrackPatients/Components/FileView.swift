//
//  FileView.swift
//  iTrackPatients
//
//  Created by Guren Icim on 9.01.2024.
//

import SwiftUI

struct FileView: View {
    var fileName: String
    
    var body: some View {
        HStack {
            Image(systemName: "doc.fill").font(.largeTitle)
            Text(fileName).foregroundStyle(Color((UIColor(named: "MainTextColor")!)))
        }
        
    }
}

#Preview {
    FileView(fileName: "rex")
}

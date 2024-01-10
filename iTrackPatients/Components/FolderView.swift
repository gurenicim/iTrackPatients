//
//  FolderView.swift
//  iTrackPatients
//
//  Created by Guren Icim on 31.12.2023.
//

import SwiftUI

struct FolderView: View {
    var folderName: String
    
    var body: some View {
        HStack {
            Image(systemName: "folder.fill").font(.largeTitle)
            Text(folderName).foregroundStyle(Color((UIColor(named: "MainTextColor")!)))
        }
        
    }
}

#Preview {
    FolderView(folderName: "hey")
}

//
//  DocumentBrowseView.swift
//  iTrackPatients
//
//  Created by Guren Icim on 9.01.2024.
//

import SwiftUI
import PDFKit

struct DocumentBrowseView: View {
    var absolutePath: String = ""
    var lastPathComponent: String = ""
    @State var fileList:[FileModel] = []
    @State var searchText:String = ""
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    
    var searchResults: [FileModel] {
        if searchText.isEmpty {
            return fileList
        } else {
            return fileList.filter { $0.fileName.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { name in
                    NavigationLink {
                        PDFKitView(pdfUrl: URL(fileURLWithPath: name.filePath)).scaledToFit()
                    } label: {
                        FileView(fileName: name.fileName)
                    }
                }
            }
            .navigationTitle("Files")
        }
        .searchable(text: $searchText) {
            ForEach(searchResults, id: \.self) { result in
                Text("Are you looking for \(result.fileName)?").searchCompletion(result)
            }
        }
        .onAppear(perform: {
            fileList.removeAll()
            readDir()
        })
    }
    
    func readDir() {
        let fm = FileManager.default
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        path = path.appending(component: lastPathComponent)
        
        do {
            let items = try fm.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            
            for item in items {
                let fileModel = FileModel(fileName: item.lastPathComponent, filePath: item.path())
                fileList.append(fileModel)
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
}

#Preview {
    DocumentBrowseView()
}

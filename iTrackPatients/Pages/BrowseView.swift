//
//  BrowseView.swift
//  iTrackPatients
//
//  Created by Guren Icim on 31.12.2023.
//

import SwiftUI

struct BrowseView: View {
    @State var folderList:[FolderModel] = []
    @State var searchText:String = ""
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    
    var searchResults: [FolderModel] {
        if searchText.isEmpty {
            return folderList
        } else {
            return folderList.filter { $0.folderName.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { name in
                    NavigationLink {
                        DocumentBrowseView(absolutePath: name.folderPath, lastPathComponent: name.folderName)
                    } label: {
                        FolderView(folderName: name.folderName)
                    }
                }
            }
            .navigationTitle("Patients")
        }
        .searchable(text: $searchText) {
            ForEach(searchResults, id: \.self) { result in
                Text("Are you looking for \(result.folderName)?").searchCompletion(result)
            }
        }
        .onAppear(perform: {
            folderList.removeAll()
            readDir()
        })
    }
    
    func readDir() {
        let fm = FileManager.default
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        do {
            let items = try fm.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)

            for item in items {
                let fModel = FolderModel(folderName: item.lastPathComponent, folderPath: item.path())
                folderList.append(fModel)
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
}


#Preview {
    BrowseView()
}

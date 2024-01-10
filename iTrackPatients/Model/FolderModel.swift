//
//  FolderModel.swift
//  iTrackPatients
//
//  Created by Guren Icim on 31.12.2023.
//

import Foundation

struct FolderModel: Hashable, Identifiable {
    var id = UUID()
    var folderName: String
    var folderPath: String
    public init(folderName: String, folderPath: String) {
        self.folderName = folderName
        self.folderPath = folderPath
    }
}

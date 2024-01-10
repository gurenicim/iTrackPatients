//
//  FileModel.swift
//  iTrackPatients
//
//  Created by Guren Icim on 9.01.2024.
//

import Foundation

struct FileModel: Hashable, Identifiable {
    var id = UUID()
    var fileName: String
    var filePath: String
    public init(fileName: String, filePath: String) {
        self.fileName = fileName
        self.filePath = filePath
    }
}

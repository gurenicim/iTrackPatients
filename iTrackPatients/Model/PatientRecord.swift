//
//  PatientRecord.swift
//  iTrackPatients
//
//  Created by Guren Icim on 31.12.2023.
//

import Foundation
struct PatientRecord {
    var fileName: String
    var filePath: String
    
    init(fileName: String, filePath: String) {
        self.fileName = fileName
        self.filePath = filePath
    }
}

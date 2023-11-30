//
//  FileDocumentManager.swift
//  TuringMachine
//
//  Created by Snow Lukin on 28.11.2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileDocumentManager: FileDocument {

    static var readableContentTypes: [UTType] { [ .mtms ] }

    var algorithm: Algorithm

    init(algorithm: Algorithm) {
        self.algorithm = algorithm
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let dataAlgorithm = try? JSONDecoder().decode(Algorithm.self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        algorithm = dataAlgorithm
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encodedData = try JSONEncoder().encode(algorithm)
        let fileWrapper = FileWrapper(regularFileWithContents: encodedData)
        return fileWrapper
    }
}

extension UTType {
    static var mtms: UTType {
        UTType(importedAs: "com.SnowLukin.TuringMachine.MultilineTuringMachineData")
    }
}

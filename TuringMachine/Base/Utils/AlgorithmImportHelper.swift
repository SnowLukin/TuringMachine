//
//  AlgorithmImportHelper.swift
//  TuringMachine
//
//  Created by Snow Lukin on 28.11.2023.
//

import Foundation
import CoreData

enum ImportError: Error {
    case urlNotFound
    case dataAccessError(URL)
    case decodingError
    case securityScopeAccessError
    case other(Error)

    var localizedDescription: String {
        switch self {
        case .urlNotFound:
            return "No URL found in the result."
        case .dataAccessError(let url):
            return "Failed to access data from the URL: \(url)."
        case .decodingError:
            return "Failed to decode the algorithm from the file."
        case .securityScopeAccessError:
            return "Failed to access security scoped resource."
        case .other(let error):
            return error.localizedDescription
        }
    }
}

struct AlgorithmImportHelper {
    func handleImport(_ result: Result<[URL], Error>, folder: CDFolder, context: NSManagedObjectContext) throws {
        do {
            guard let selectedFileURL = try result.get().first else {
                throw ImportError.urlNotFound
            }

            if selectedFileURL.startAccessingSecurityScopedResource() {
                defer { selectedFileURL.stopAccessingSecurityScopedResource() }

                guard let data = try? Data(contentsOf: selectedFileURL) else {
                    throw ImportError.dataAccessError(selectedFileURL)
                }

                guard let algorithm = try? JSONDecoder().decode(Algorithm.self, from: data) else {
                    throw ImportError.decodingError
                }

                _ = try? CDAlgorithm.create(from: algorithm, folder: folder, in: context)
                print("Algorithm imported successfully.")
            } else {
                throw ImportError.securityScopeAccessError
            }
        } catch let error as ImportError {
            print("Import Error: \(error.localizedDescription)")
        } catch {
            throw ImportError.other(error)
        }
    }
}

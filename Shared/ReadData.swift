//
//  ReadData.swift
//  EightBall
//
//  Created by Сергій Костриця on 28.01.2022.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct InputDoument: FileDocument {

    static var readableContentTypes: [UTType] { [.plainText] }

    var input: String

    init(input: String) {
        self.input = input
    }

    init(configuration: FileDocumentReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        input = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: input.data(using: .utf8)!)
    }

}

struct EightBallMagicResponse: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case question
        case answer
        case type
    }
    
    var id = UUID()
    var question: String
    var answer: String
    var type: String
}

struct EightBallResponse: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case magic
    }
    
    var id = UUID()
    var magic: EightBallMagicResponse
}

struct Answers: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case answers
    }
    
    var id = UUID()
    var answers : [String]
}

class ReadData<T: Decodable>: ObservableObject  {
    @Published var response: T? = nil
    
    init(json: Data?){
        loadData(json)
    }
    
    func loadData(_ json: Data?)  {
        let response = try? JSONDecoder().decode(T.self, from: json!)
        self.response = response!
    }
}

//
//  ReadData.swift
//  EightBall
//
//  Created by Сергій Костриця on 28.01.2022.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

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

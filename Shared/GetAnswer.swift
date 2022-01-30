//
//  GetAnswer.swift
//  EightBall
//
//  Created by Сергій Костриця on 29.01.2022.
//

import Foundation

func getRandomAnswer(_ appSettings: Settings) -> String
{
    let urlString = "https://8ball.delegator.com/magic/JSON/hope"
    let url = URL(string: urlString)!
    let data = try? Data(contentsOf: url)
    
    if data != nil, let response = ReadData<EightBallResponse>(json: data).response {
        return response.magic.answer;
    }
    
    return !appSettings.answers.isEmpty
    ? appSettings.answers.randomElement()!
    :"I don't know("
}

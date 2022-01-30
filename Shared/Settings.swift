//
//  Settings.swift
//  EightBall
//
//  Created by Сергій Костриця on 30.01.2022.
//

import Foundation

class Settings: ObservableObject {
    @Published var isPlayButtonVisible: Bool = true
    @Published var isSettingsButtonVisible: Bool = true
    @Published var isHintTextVisible: Bool = false
    @Published var isNewAnswerTextFieldVisible: Bool = false
    @Published var hintText = "Shake Me!"
    @Published var answers = [
        "Yes",
        "No",
        "Propably Yes",
        "Propably Not",
        "Try Again",
    ]
    @Published var newAnswer = ""
}

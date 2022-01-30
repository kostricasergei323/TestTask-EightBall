//
//  ContentView.swift
//  Shared
//
//  Created by Сергій Костриця on 28.01.2022.
//

import SwiftUI

extension NSNotification.Name {
    public static let deviceDidShakeNotification = NSNotification.Name("MyDeviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
    }
}


struct SettingsView: View {
    @ObservedObject var appSettings: Settings
    
    var body: some View {
        NavigationView{
            List {
                ForEach(
                    appSettings.answers,
                    id: \.self
                ) { answer in
                    Text(answer)
                }
                .onDelete {appSettings.answers.remove(atOffsets: $0) }
                
            }
            .navigationTitle("Answers")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        appSettings.isSettingsButtonVisible = !appSettings.isSettingsButtonVisible
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                
                ToolbarItem(placement: .principal){
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        appSettings.isNewAnswerTextFieldVisible = !appSettings.isNewAnswerTextFieldVisible
                        appSettings.newAnswer = ""
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                    }
                }
                
                ToolbarItem(placement: .bottomBar)
                {
                    TextField(
                        "New Answer",
                        text: $appSettings.newAnswer
                    )
                        .onSubmit {
                            appSettings.answers.append(appSettings.newAnswer)
                            appSettings.isNewAnswerTextFieldVisible = false
                            appSettings.newAnswer = ""
                        }
                        .scaledToFill()
                        .disableAutocorrection(true)
                        .border(.blue)
                        .opacity(appSettings.isNewAnswerTextFieldVisible ? 1 : 0)
                }
            }
        }
    }
}

struct MainView: View {
    @ObservedObject var appSettings: Settings
    
    var body: some View {
        VStack (alignment: .trailing) {
            Button {
                appSettings.isSettingsButtonVisible = !appSettings.isSettingsButtonVisible
            } label: {
                Image(systemName: "gearshape.fill")
                    .resizable(resizingMode: .tile)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(Color.black)
            }
            .frame(width: 60, height: 60)
            
            ZStack {
                Image("BackgroundImg")
                    .resizable()
                    .scaledToFit()
                
                Button {
                    appSettings.isPlayButtonVisible = false
                    appSettings.isHintTextVisible = true
                } label: {
                    Image(systemName: "play")
                        .resizable()
                        .frame(width: 75.0, height: 75.0, alignment: .center)
                        .offset(x: 8)
                }
                .opacity( appSettings.isPlayButtonVisible ? 1 : 0)
                
                Text(appSettings.hintText)
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .opacity(appSettings.isHintTextVisible ? 1 : 0)
                    .frame(width: 120, alignment: .center)
                    .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                        if appSettings.isHintTextVisible {
                            appSettings.hintText = getRandomAnswer(appSettings)
                        }
                    }
            }
        }
    }
}

struct ContentView: View {
    @StateObject var appSettings = Settings()
    
    var body: some View {
        if appSettings.isSettingsButtonVisible {
            MainView(appSettings: appSettings)
        }
        else {
            SettingsView(appSettings: appSettings)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

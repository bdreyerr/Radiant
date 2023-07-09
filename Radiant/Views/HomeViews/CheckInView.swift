//
//  CheckInView.swift
//  Radiant
//
//  Created by Ben Dreyer on 7/9/23.
//

import SwiftUI

struct CheckInView: View {
    @State private var happinessSliderValue = 5.0
    @State private var depressionSliderValue = 5.0
    @State private var anxietySliderValue = 5.0
    
    var body: some View {
        
        ZStack {
            Image("Login_Email_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("Rate your happiness today:")
                    .foregroundColor(.white)
                Slider(value: $happinessSliderValue, in:0...10, step: 1) {
                    Text("Value: \(happinessSliderValue)")
                }
                .frame(width: 400)
                .padding(.bottom, 40)
                
                Text("Rate your happiness today:")
                    .foregroundColor(.white)
                Slider(value: $depressionSliderValue, in:0...10, step: 1) {
                    Text("Value: \(depressionSliderValue)")
                }
                .frame(width: 400)
                .padding(.bottom, 40)
                
                Text("Rate your happiness today:")
                    .foregroundColor(.white)
                Slider(value: $anxietySliderValue, in:0...10, step: 1) {
                    Text("Value: \(anxietySliderValue)")
                }
                .frame(width: 400)
                
                
                Button(action: {
                    print("user wanted to go next")
                }) {
                    HStack {
                        Text("Next")
                            .foregroundColor(.white)
                            .font(.system(size: 30, design: .monospaced))
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    
                }
                .offset(y: 200)
            }
            
            
        }
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
    }
}

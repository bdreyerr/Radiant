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
        
        NavigationView {
            
            ZStack {
                Image("Login_Email_BG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Text("Please rate your happiness today: ")
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        .font(.system(size: 18, design: .monospaced))
                        .bold()
                    CirclularSlider()
                    
                    
                    NavigationLink(destination: DepressionView()) {
                        Text("Next")
                            .foregroundColor(.white)
                            .font(.system(size: 30, design: .monospaced))
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    .offset(y: 200)
                }
            }
        }
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
    }
}


struct DepressionView: View {
    var body: some View {
        
        
        ZStack {
            Image("Login_Email_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("Please rate your depression today: ")
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .font(.system(size: 18, design: .monospaced))
                    .bold()
                CirclularSlider()
                
                NavigationLink(destination: AnxeityView()) {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(.system(size: 30, design: .monospaced))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .offset(y: 200)
            }
            
        }
    }
}


struct AnxeityView: View {
    var body: some View {
        
        ZStack {
            Image("Login_Email_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("Please rate your anxiety today: ")
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .font(.system(size: 18, design: .monospaced))
                    .bold()
                CirclularSlider()
                
                NavigationLink(destination: HomeMainView()) {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(.system(size: 30, design: .monospaced))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .offset(y: 200)
                
            }
        }
    }
}

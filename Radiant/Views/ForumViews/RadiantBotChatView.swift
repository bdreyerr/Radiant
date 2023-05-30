//
//  RadiantBotChatView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/30/23.
//

import SwiftUI

struct RadiantBotChatView: View {
    
    @State var text: String
    
    var body: some View {
        ZStack {
            
            VStack {
                
                Text("Radiant Chat")
                    .font(.system(size: 24))
                
                
                // This is the scroll view.
                ScrollView {
                    
                    // Messages
                    VStack(alignment: .leading) {
                        
                        // Message from you
                        MessageFromYou(text: "Hi Radiant Bot, you're so cool!")
                        
                        
                        // Message from Radiant Bot
                        MessageFromBot(text: "You know it G")
                        
                        
                        MessageFromYou(text: "Can you help me with my issues?")
                        
                        MessageFromBot(text: "Of course homie")
                    }
                    
                }.padding(.top, 20)
                
                // Message send bar
                
                HStack {
                    TextField("Enter text", text: $text)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 40).foregroundColor(.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 2)
                        )
                        .overlay(
                            Button(action: {
                                print("User sent a message")
                                self.text = ""
                            }) {
                                Image(systemName: "paperplane")
                                    .resizable()
                                    .frame(maxWidth: 30, maxHeight: 30, alignment: .trailing)
                                    .padding(.leading, 280)
                                    .foregroundColor(.blue)
                            }
                            
                        )
                        .foregroundColor(.black)
                        .frame(width: 360)
                        .padding(.bottom, 100)
                }
            }
        }
        .background(Color.clear)
    }
}

struct RadiantBotChatView_Previews: PreviewProvider {
    static var previews: some View {
        RadiantBotChatView(text: "")
    }
}


struct MessageFromYou : View {
    let text: String?
    var body: some View {
        
        HStack {
            ZStack {
                // Create the bubble shape
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue)
                
                // Add the text content
                Text(text ?? "No text")
                    .padding()
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 300, maxHeight: 30)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.leading, 60)
            
            Image("default_prof_pic")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.trailing, 10)
            
        }
        .padding(.trailing, 10)
        
    }
}

struct MessageFromBot : View {
    let text: String?
    var body: some View {
        
        HStack {
            Image("RadiantBotPic")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.trailing, 10)
            
            ZStack {
                // Create the bubble shape
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.80))
                
                // Add the text content
                Text(text ?? "No text")
                    .padding()
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 160, maxHeight: 30)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.leading, 0)
        }
        .padding(.leading, 10)
        
    }
}

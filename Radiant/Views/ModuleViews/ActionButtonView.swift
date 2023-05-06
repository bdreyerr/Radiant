//
//  ActionButtonView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/3/23.
//

import SwiftUI

struct ActionButtonView: View {
    var text: String?
    var symbolName: String?
    var action: (() -> Void)?
    
    var body: some View {
        
        if let text, let symbolName, let action {
            Button(action: action) {
                // Action icon
                Image(systemName: symbolName).foregroundColor(.black).font(.system(size: 25))
                
                // Action text
                Text(text).font(.system(size: 25))
                    .fontWeight(.light)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                
            }.frame(width: 350)
                .cornerRadius(50)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.white, lineWidth: 2))
        }
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonView()
    }
}

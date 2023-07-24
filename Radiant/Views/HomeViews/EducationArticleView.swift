//
//  EducationArticleView.swift
//  Radiant
//
//  Created by Ben Dreyer on 7/23/23.
//

import SwiftUI

struct EducationArticleView: View {
    var bg_image = "Forum_BG2"
    var completed: Bool = true
    var title: String
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(minWidth: 250, maxWidth: 300, minHeight: 200, maxHeight: 200)
            .foregroundColor(.blue)
            .overlay {
                ZStack {
                    Image(bg_image)
                        .resizable()
                        .cornerRadius(25)
                    
                    VStack {
                        if completed {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.green)
                                .offset(y: -40)
                                .offset(x: 100)
                            
                        }
                        
                        Text(title)
                            .foregroundColor(.white)
                            .padding(.bottom, 40)
                    }
                }
            }
    }
}

struct EducationArticleView_Previews: PreviewProvider {
    static var previews: some View {
        EducationArticleView(title: "Base Education Article")
    }
}

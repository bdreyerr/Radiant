//
//  ForumCategoriesView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/30/23.
//

import SwiftUI

struct ForumCategoriesView: View {
    var body: some View {
        
        ZStack {
            
            VStack {
                
                Text("Radiant Community")
                    .font(.system(size: 24))
                
                
                // This is the scroll view.
                ScrollView {
                    // Tab to switch to chat
                    
                    
                    VStack(alignment: .leading) {
                        // General
                        NavigationLink(destination: ForumDetailedView(title: "General")) {
                            ListItem(icon: "person.2.circle", title: "General", description: "This is the description of each category.")
                        }
                        
                        
                        // Depression
                        NavigationLink(destination: ForumDetailedView(title: "Depression")) {
                            ListItem(icon: "brain.head.profile", title: "Depression", description: "This is the description of each category. Ok there is a little more to the description for this one.")
                        }
                        
                        // Stress and Anxiety
                        NavigationLink(destination: ForumDetailedView(title: "Stress and Anxiety")) {
                            ListItem(icon: "bubbles.and.sparkles", title: "Stress and Anxiety", description: "This is the description of each category.")
                        }
                        
                        
                        
                        // Relationships
                        NavigationLink(destination: ForumDetailedView(title: "Relationships")) {
                            ListItem(icon: "person.2.wave.2", title: "Relationships", description: "This is the description of each category.")
                        }
                        
                        // Recovery
                        NavigationLink(destination: ForumDetailedView(title: "Recovery")) {
                            ListItem(icon: "microbe", title: "Recovery", description: "This is the description of each category.")
                        }
                        
                        // Addiction
                        NavigationLink(destination: ForumDetailedView(title: "Addiction")) {
                            ListItem(icon: "pills", title: "Addiction", description: "This is the description of each category.")
                        }
                        
                        // Sobriety
                        NavigationLink(destination: ForumDetailedView(title: "Sobriety")) {
                            ListItem(icon: "aqi.medium", title: "Sobriety", description: "This is the description of each category. Testing to see, god damn it.")
                        }
                        
                        // Personal Stories
                        NavigationLink(destination: ForumDetailedView(title: "Personal Stories")) {
                            ListItem(icon: "quote.bubble", title: "Personal Stories", description: "This is the description of each category. Testing to see, god damn it.")
                        }
                        
                        // Advice
                        NavigationLink(destination: ForumDetailedView(title: "Advice")) {
                            ListItem(icon: "person.crop.rectangle.stack", title: "Advice", description: "This is the description of each category. Testing to see, god damn it.")
                        }
                    }
                    //                        .frame(alignment: .leading)
                    //                        .padding(.trailing, 100)
                    
                    
                }.padding(.top, 20)
            }
        }
        .background(Color.clear)
        
    }
}

struct ForumCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        ForumCategoriesView()
    }
}


struct ListItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .fixedSize(horizontal: true, vertical: true)
                VStack(alignment: .leading) {
                    Text(title)
                        .bold()
                    Text(description)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.leading)
                        .frame(alignment: .leading)
                }
            }
            .contentShape(Rectangle())
            .padding(.leading, 20)
            .padding(.bottom, 10)
    }
}

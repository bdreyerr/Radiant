//
//  MapMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/7/23.
//

import SwiftUI

struct MapMainView: View {
    var body: some View {
        ZStack {
            Image("Map_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Text("Welcome to the Map View!").foregroundColor(.white)
        }
    }
}

struct MapMainView_Previews: PreviewProvider {
    static var previews: some View {
        MapMainView()
    }
}

//
//  MapMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/7/23.
//

import SwiftUI
import MapKit

struct MapMainView: View {
    
    @StateObject var mapManager = MapManager()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapManager.region, annotationItems: mapManager.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Button(action: {
                        mapManager.isDetailedPopupShowing = true
                    }) {
                        MapPinAnnotation(icon: "heart")
                    }.sheet(isPresented: $mapManager.isDetailedPopupShowing) {
                        Text("You clicked on a doctor brother")
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                //Bubbles
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        MapFilterBubble(text: "Therapists", icon: "heart.text.square", isSelected: true, filterNumber: 0)
                        MapFilterBubble(text: "Primary Care", icon: "cross", isSelected: false, filterNumber: 1)
                        MapFilterBubble(text: "Pyshcology", icon: "person.wave.2", isSelected: false, filterNumber: 2)
                        MapFilterBubble(text: "Fitness", icon: "figure.run.circle", isSelected: false, filterNumber: 3)
                        MapFilterBubble(text: "Rehabilitation", icon: "bandage", isSelected: false, filterNumber: 4)
                    }
                    .padding(.top, 20)
                    .padding(.leading, 20)
                }
                
                switch mapManager.locationManager.authorizationStatus {
                case .authorizedWhenInUse: // Location services are available
                    Text("Your current latitude is: \(mapManager.locationManager.location?.coordinate.latitude.description ?? "Error loading latitude")")
                    Text("Your current longitude is: \(mapManager.locationManager.location?.coordinate.longitude.description ?? "Error loading latitude")")
                case .restricted, .denied: // Location services unavailable
                    Text("Current location data was restricted or denied")
                case .notDetermined:
                    Text("Finding location: ....")
                default:
                    ProgressView()
                }
                
                Spacer()
            }
            
        }
        .environmentObject(mapManager)
    }
}

struct MapMainView_Previews: PreviewProvider {
    static var previews: some View {
        MapMainView()
            .environmentObject(MapManager())
    }
}


struct MapFilterBubble: View {
    
    @EnvironmentObject var mapManager: MapManager
    
    let text: String?
    let icon: String?
    @State var isSelected: Bool?
    let filterNumber: Int?
    
    var body: some View {
        Button(action: {
            print("user selected ", text!)
            mapManager.focusedFilter = self.filterNumber!
        }) {
            
            if self.filterNumber! == mapManager.focusedFilter {
                RoundedRectangle(cornerRadius: 30)
                    .frame(minWidth: 160, maxHeight: 40)
                    .foregroundColor(.white)
                    .overlay {
                        ZStack {
                            HStack {
                                Image(systemName: icon!)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.black)
                                
                                Text(text!)
                                    .foregroundColor(.green)
                                    .font(.system(size: 16, design: .serif))
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .animation(.easeInOut(duration: 1.0))
            } else {
                RoundedRectangle(cornerRadius: 30)
                    .frame(minWidth: 160, maxHeight: 40)
                    .foregroundColor(.white)
                    .overlay {
                        HStack {
                            Image(systemName: icon!)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                            
                            Text(text!)
                                .foregroundColor(.black)
                                .font(.system(size: 16, design: .serif))
                        }
                    }
                    .animation(.easeInOut(duration: 1.0))
            }
        }
    }
}

struct MapPinAnnotation: View {
    
    let icon: String?
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .shadow(radius: 10)
            
            Image(systemName: icon!)
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(.black)
        }
        
    }
}

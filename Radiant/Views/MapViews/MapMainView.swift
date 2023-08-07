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
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 37.80341200169129,
            longitude:  -122.40623140737449),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03)
    )
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapManager.region, annotationItems: mapManager.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Button(action: {
                        mapManager.isDetailedPopupShowing = true
                    }) {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                    }.sheet(isPresented: $mapManager.isDetailedPopupShowing) {
                        Text("You clicked on a doctor brother")
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                //Bubbles
                HStack {
                    Button(action: {
                        print("user changed to therapist")
                    }) {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 120, height: 40)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.845))
                            .overlay {
                                Text("Therapists")
                                    .foregroundColor(.black)
                            }
                    }
                    
                    Button(action: {
                        print("user changed to therapist")
                    }) {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 120, height: 40)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.845))
                            .overlay {
                                Text("Psychologists")
                                    .foregroundColor(.black)
                            }
                    }
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

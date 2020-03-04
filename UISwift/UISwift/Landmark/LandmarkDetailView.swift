//
//  LandmarkDetailView.swift
//  UISwift
//
//  Created by zjj on 2020/2/24.
//  Copyright © 2020 zjj. All rights reserved.
//

import SwiftUI
import MapKit

struct LandmarkDetailView: View {
    @EnvironmentObject var userData: UserData
    var landmark: Landmark
    var landmarkIndex: Int {
        userData.landmarks.firstIndex { (la) -> Bool in
            la.id == landmark.id
        }!
    }
    var body: some View {
        VStack {
            MapView(coordinate: landmark.locationCoordinate)
                .frame(height: 300)
            
            landmark.image.resizable()
                .clipShape(Circle())
                .overlay(Circle()
                .stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .frame(width: 200, height: 200)
                .offset(y: -100)
                .padding(.bottom, -100)
                
                
            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name)
                    .font(.title)
                    .fontWeight(.bold)
                    Button(action: {
                        self.userData.landmarks[self.landmarkIndex].isFavorite.toggle()
                    }) {
                        if self.userData.landmarks[self.landmarkIndex].isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(Color.gray)
                        }
                    }
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 10.0)
                
                HStack {
                    Text(landmark.park)
                        .font(.subheadline)
                    Spacer()
                    Text(landmark.state)
                    .font(.subheadline)
                }
            }
            .padding()
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
//        .navigationBarTitle(Text(landmark.name), displayMode: .automatic)
    }
}

struct LandmarkDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetailView(landmark: landmarkData[0]).environmentObject(UserData())
//            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
}

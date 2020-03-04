//
//  LandmarkListView.swift
//  UISwift
//
//  Created by zjj on 2020/2/24.
//  Copyright © 2020 zjj. All rights reserved.
//

import SwiftUI

struct LandmarkListView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
//        NavigationView {
            List{
                Toggle(isOn: $userData.showFavoritesOnly) {
                    Text("Favorites Only")
                }
                ForEach(self.userData.landmarks) { landmark in
                    if !self.userData.showFavoritesOnly || landmark.isFavorite {
                        NavigationLink(destination: LandmarkDetailView(landmark: landmark)) {
                            LandmarkRow(landmark: landmark)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Landmarks"))
//        }
    }
}

struct LandmarkListView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkListView().environmentObject(UserData())
    }
}

struct LandmarkRow: View {
    var landmark: Landmark
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            Spacer()
            if landmark.isFavorite {
                Image(systemName: "star.fill")
                .imageScale(.medium)
                .foregroundColor(.yellow)
            }
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarkData[0])
            LandmarkRow(landmark: landmarkData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}

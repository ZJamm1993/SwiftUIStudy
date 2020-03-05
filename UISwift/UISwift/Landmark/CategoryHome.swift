//
//  CategoryHome.swift
//  UISwift
//
//  Created by zjj on 2020/2/27.
//  Copyright © 2020 zjj. All rights reserved.
//

import SwiftUI

struct CategoryItem: View {
    var item: Landmark
    var body: some View {
        VStack(alignment: .leading) {
            item.image.resizable().renderingMode(.original)
            .frame(width: 140, height: 140)
            .cornerRadius(10)
            Text(item.name)
                .font(.caption).foregroundColor(.primary)
            // 不加这个renderingMode和foregroundColor的话，
            // 在NavigationLink里面会变成蓝色！！
        }
    }
}

struct CategoryRow: View {
    var name: String
    var items: [Landmark]
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.name)
                .font(.headline)
//                .padding(.leading, 15)
                .padding(.top, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    ForEach(self.items) {
                        it in
                       NavigationLink(destination: LandmarkDetailView(landmark: it)) {
                            CategoryItem(item: it)
                        }
                    }
                }
                .padding(.trailing, 15)
            }
        }
        .padding(.bottom, 10)
        .padding(.leading, 15)
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(
            name: landmarkData[0].category.rawValue,
            items: Array(landmarkData.prefix(4))
        )
        .previewLayout(.fixed(width: 320, height: 400))
    }
}


struct FeaturedLandmarks: View {
    var landmarks: [Landmark]
    var body: some View {
        landmarks[0].image.resizable()
    }
}

struct CategoryHome: View {
    var categories: [String: [Landmark]] {
        Dictionary(grouping: landmarkData, by: {
            $0.category.rawValue
        })
    }
    var featured: [Landmark] {
        landmarkData.filter {
            $0.isFavorite
        }
    }
    
    @State var showingProfile = false
    @EnvironmentObject var userData: UserData
    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                /*
                FeaturedLandmarks(landmarks: self.featured)
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
 */
                PageView(features.map { FeatureCard(landmark: $0) })
                    .frame(height:200)
                    .listRowInsets(EdgeInsets())
                ForEach(categories.keys.sorted(), id:\.self) {
                    cateName in
                    CategoryRow(name: cateName, items: self.categories[cateName]!)
                    .listRowInsets(EdgeInsets())
                }
                NavigationLink(destination: LandmarkListView()) {
                    Text("See All")
                }
            }
            .navigationBarTitle("Features")
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $showingProfile) {
                ProfileHost().environmentObject(self.userData)
            }
        }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
    }
}


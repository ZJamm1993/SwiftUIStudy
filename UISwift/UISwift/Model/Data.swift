//
//  Data.swift
//  UISwift
//
//  Created by zjj on 2020/3/5.
//  Copyright © 2020 zjj. All rights reserved.
//

import UIKit

final class UserData: ObservableObject  {
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
    @Published var profile = Profile.default
}

let landmarkData: [Landmark] = load("landmarkData.json")
let hikeData: [Hike] = load("hikeData.json")
let features = landmarkData.filter { (lan) -> Bool in
    return lan.isFeatured
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

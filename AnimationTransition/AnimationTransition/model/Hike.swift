/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for a hike.
*/

import SwiftUI

let bundlepath = Bundle.main.path(forResource: "Data", ofType: "bundle")!
let dataPath = bundlepath.appending("/hikeData.json")
public let hikeData: [Hike] = load(dataPath)

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    do {
        data = try Data(contentsOf:URL(fileURLWithPath: filename))
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

public struct Hike: Codable, Hashable, Identifiable {
    var name: String
    public var id: Int
    var distance: Double
    var difficulty: Int
    var observations: [Observation]

    static var formatter = LengthFormatter()
    
    var distanceText: String {
        return Hike.formatter
            .string(fromValue: distance, unit: .kilometer)
    }

    struct Observation: Codable, Hashable {
        var distanceFromStart: Double
        
        var elevation: Range<Double>
        var pace: Range<Double>
        var heartRate: Range<Double>
    }
}

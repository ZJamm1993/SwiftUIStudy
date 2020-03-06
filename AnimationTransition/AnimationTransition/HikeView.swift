/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view displaying information about a hike, including an elevation graph.
*/

import SwiftUI

extension AnyTransition {
    static var moveAndFade : AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing).combined(with: .opacity)
        let removal = AnyTransition.scale.combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}


struct HikeDetail: View {
    let hike: Hike
    @State var dataToShow = \Hike.Observation.elevation
    
    var buttons = [
        ("Elevation", \Hike.Observation.elevation),
        ("Heart Rate", \Hike.Observation.heartRate),
        ("Pace", \Hike.Observation.pace),
    ]
    
    var body: some View {
        return VStack {
            HikeGraph(hike: hike, path: dataToShow)
            
            HStack(spacing: 25) {
                ForEach(buttons, id: \.0) { value in
                    Button(action: {
                        self.dataToShow = value.1
                    }) {
                        Text(value.0)
                            .font(.system(size: 15))
                            .foregroundColor(value.1 == self.dataToShow
                                ? Color.gray
                                : Color.accentColor)
                            .animation(nil)
                    }
                }
            }
        }
    }
}

public struct HikeView: View {
    var hike: Hike
    @State private var showDetail = true
    public init(hike: Hike) {
        self.hike = hike
    }
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                HikeGraph(hike: hike, path: \.elevation)
                    .frame(width: 50, height: 30)
                    .animation(nil)
                
                VStack(alignment: .leading) {
                    Text(hike.name)
                        .font(.headline)
                    Text(hike.distanceText)
                }.frame(height:60)
                
                Spacer()

                Button(action: {
                    withAnimation {
                        self.showDetail.toggle()
                    }
                    
                }) {
                    Image(systemName: "chevron.right.circle")
                        .imageScale(.large)
                    .rotationEffect(.degrees(showDetail ? 90 : 0))
                        .scaleEffect(showDetail ? 1.2 : 1.0)
                        .padding()
//                        .animation(.spring())
                }.frame(width: 60, height: 60)
            }
            if showDetail {
                HikeDetail(hike: hike)
                    .transition(.moveAndFade)
                    .frame(height:200)
            }
        }
    }
}

struct HikeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HikeView(hike: hikeData[0])
//                .previewLayout(.fixed(width: 300, height: 300))
            Spacer()
        }
    }
}

func rangeOfRanges<C: Collection>(_ ranges: C) -> Range<Double>
    where C.Element == Range<Double> {
    guard !ranges.isEmpty else { return 0..<0 }
    let low = ranges.lazy.map { $0.lowerBound }.min()!
    let high = ranges.lazy.map { $0.upperBound }.max()!
    return low..<high
}

func magnitude(of range: Range<Double>) -> Double {
    return range.upperBound - range.lowerBound
}

extension Animation {
    static func ripple(index: Int) -> Animation {
        return Animation.spring(dampingFraction:0.5).speed(2)
        .delay(0.03 * Double(index))
    }
}

struct GraphCapsule: View {
    var index: Int
    var height: CGFloat
    var range: Range<Double>
    var overallRange: Range<Double>
    
    var heightRatio: CGFloat {
        max(CGFloat(magnitude(of: range) / magnitude(of: overallRange)), 0.15)
    }
    
    var offsetRatio: CGFloat {
        CGFloat((range.lowerBound - overallRange.lowerBound) / magnitude(of: overallRange))
    }
    
    var body: some View {
        Capsule()
            .fill(Color.white)
            .frame(height: height * heightRatio)
            .offset(x: 0, y: height * -offsetRatio)
    }
}

struct HikeGraph: View {
    var hike: Hike
    var path: KeyPath<Hike.Observation, Range<Double>>
    
    var color: Color {
        switch path {
        case \.elevation:
            return .gray
        case \.heartRate:
            return Color(hue: 0, saturation: 0.5, brightness: 0.7)
        case \.pace:
            return Color(hue: 0.7, saturation: 0.4, brightness: 0.7)
        default:
            return .black
        }
    }
    
    var body: some View {
        let data = hike.observations
        let overallRange = rangeOfRanges(data.lazy.map { $0[keyPath: self.path] })
        let maxMagnitude = data.map { magnitude(of: $0[keyPath: path]) }.max()!
        let overallHeightRatio = (1 - CGFloat(maxMagnitude / magnitude(of: overallRange))) / 2
//        let capsHeightRadio = max(CGFloat(magnitude(of: range) / magnitude(of: overallRange)), 0.15)

        return GeometryReader { proxy in
            HStack(alignment: .bottom, spacing: proxy.size.width / 120) {
                ForEach(data.indices) { index in
                    GraphCapsule(
                        index: index,
                        height: proxy.size.height,
                        range: data[index][keyPath: self.path],
                        overallRange: overallRange)
                    .colorMultiply(self.color)
                    .transition(.slide)
                    .animation(.ripple(index: index))
                    .offset(x: 0, y: proxy.size.height * overallHeightRatio)
                }
            }
        }
    }
}

struct HikeGraph_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HikeGraph(hike: hikeData[0], path: \.elevation)
            HikeGraph(hike: hikeData[0], path: \.heartRate)
            HikeGraph(hike: hikeData[0], path: \.pace)
        }.previewLayout(.fixed(width: 300, height: 200))
    }
}

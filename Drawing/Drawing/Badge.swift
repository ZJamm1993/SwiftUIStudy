//
//  Badge.swift
//  Drawing
//
//  Created by zjj on 2020/2/24.
//  Copyright © 2020 zjj. All rights reserved.
//

import SwiftUI

struct Badge: View {
    static let rotationCount = 9
    var badgeSymbols: some View {
        ForEach(0..<Self.rotationCount) { i in
            RotatedBadgeSymbol(angle: .init(degrees: 360.0 * Double(i) / Double(Self.rotationCount))).opacity(0.5)
        }
        
    }
    var body: some View {
        ZStack {
            BadgeBackground()
            GeometryReader { geo in
                self.badgeSymbols
                    .scaleEffect(1.0 / 4.0, anchor: .top)
                    .position(x: geo.size.width / 2.0, y: geo.size.height / 4.0 * 3.0)
            }
            
        }
        .scaledToFit()
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}


struct RotatedBadgeSymbol: View {
    let angle: Angle
    
    var body: some View {
        BadgeSymbol()
            .padding(-60)
            .rotationEffect(angle, anchor: .bottom)
    }
}

struct RotatedBadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        RotatedBadgeSymbol(angle: .init(degrees: 5))
    }
}

struct BadgeSymbol: View {
    static let symbolColor = Color(red: 79.0 / 255, green: 79.0 / 255, blue: 191.0 / 255)

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 0.75
                let spacing = width * 0.020
                let middle = width / 2
                let topWidth = 0.226 * width
                let topHeight = 0.488 * height
                
                path.addLines([
                    CGPoint(x: middle, y: spacing),
                    CGPoint(x: middle - topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: topHeight / 2 + spacing),
                    CGPoint(x: middle + topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: spacing)
                ])
                path.move(to: CGPoint(x: middle, y: topHeight / 2 + spacing * 3))
                path.addLines([
                    CGPoint(x: middle - topWidth, y: topHeight + spacing),
                    CGPoint(x: spacing, y: height - spacing),
                    CGPoint(x: width - spacing, y: height - spacing),
                    CGPoint(x: middle + topWidth, y: topHeight + spacing),
                    CGPoint(x: middle, y: topHeight / 2 + spacing * 3)
                ])
            }.fill(Self.symbolColor)
        }
    }
}

struct BadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        BadgeSymbol()
    }
}

struct BadgeBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                    var width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    let xScale: CGFloat = 0.832
                    let xOffset = (width * (1.0 - xScale)) / 2.0
                    width *= xScale
                    path.move(
                        to: CGPoint(
                            x: xOffset + width * 0.95,
                            y: height * (0.20 + HexagonParameters.adjustment)
                        )
                    )
                    
                    HexagonParameters.points.forEach {
                        path.addLine(
                            to: .init(
                                x: xOffset + width * $0.useWidth.0 * $0.xFactors.0,
                                y: height * $0.useHeight.0 * $0.yFactors.0
                            )
                        )
                        
                        path.addQuadCurve(
                            to: .init(
                                x: xOffset + width * $0.useWidth.1 * $0.xFactors.1,
                                y: height * $0.useHeight.1 * $0.yFactors.1
                            ),
                            control: .init(
                                x: xOffset + width * $0.useWidth.2 * $0.xFactors.2,
                                y: height * $0.useHeight.2 * $0.yFactors.2
                            )
                        )
                    }
                }
                .fill(LinearGradient(
                    gradient: .init(colors: [Self.gradientStart, Self.gradientEnd]),
                    startPoint: .init(x: 0.5, y: 0),
                    endPoint: .init(x: 0.5, y: 0.6)
                ))
                .aspectRatio(1, contentMode: .fit)
        }
    }
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
}

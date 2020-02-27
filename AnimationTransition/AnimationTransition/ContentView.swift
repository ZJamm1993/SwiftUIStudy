//
//  ContentView.swift
//  AnimationTransition
//
//  Created by zjj on 2020/2/27.
//  Copyright © 2020 zjj. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HikeView(hike: hikeData[0])
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

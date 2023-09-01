//
//  RainbowView.swift
//  Demo
//
//  Created by David Walter on 14.08.23.
//

import SwiftUI

struct RainbowView: View {
    var body: some View {
        Group {
            Color.red
            Color.orange
            Color.yellow
            Color.green
            Color.blue
            Color.purple
        }
    }
}

struct RainbowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RainbowView()
        }
    }
}

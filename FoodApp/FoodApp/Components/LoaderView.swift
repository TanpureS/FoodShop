//
//  LoaderView.swift
//  FoodApp
//
//  Created by Shivaji Tanpure on 09/09/23.
//

import SwiftUI

struct LoaderView: View {
    @State var isLoading = false
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.green, lineWidth: 5)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(.linear
                    .repeatForever(autoreverses: false), value: isLoading)
                .onAppear {
                    isLoading = true
                }
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}

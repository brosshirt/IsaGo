//
//  Loader.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 1/14/23.
//

import SwiftUI

struct Loader: View {
    
    @State var animate = false
    
    var body: some View {
        
        NavigationView{ // if you're not inside a navigation view the animation behaves weirdly, idk
            VStack{
                Circle()
                    .trim(from: 0, to: 0.8)
                    .stroke(AngularGradient(gradient: .init(colors: [.blue, .gray]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 45, height: 45)
                    .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                    .padding(.top, 10)
                Text("Lesson loading...")
            }
            .onAppear{
                withAnimation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false)) {
                    animate.toggle()
                }
            }
        }
        
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}

//
//  HomeView.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/20/22.
//

import SwiftUI
import Foundation




let decoder = JSONDecoder()




struct HomeView: View {
    @State var selectClasses = false
    
    @Binding var classes: Classes

    var body: some View {
        if (selectClasses){
            AddDropView(classes: $classes)
        }
        else{
            Text("My Classes")
                .font(.largeTitle)
                .padding()
            List(classes.taking, id: \.self) { item in
                Text(item.class_name)
            }
            Button(action:{
                selectClasses = true
            }){
                Text("Add/Drop").foregroundColor(.blue)
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

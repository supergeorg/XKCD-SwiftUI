//
//  AboutView.swift
//  XKCD
//
//  Created by Georg Meissner on 03.08.20.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .center){
                    Text("This app was developed in 2020 by Georg Meißner.").font(.headline)
                    Text("Written in Swift and SwiftUI.").font(.body)
                    HStack{
                        Image(systemName: "swift").font(.largeTitle)
                        Image(systemName: "applelogo").font(.largeTitle)
                    }
                    Spacer()
                    Divider()
            Text("The comics are used under the Creative Commons Attribution-NonCommercial 2.5 Generic (CC BY-NC 2.5).").font(.caption)
                    HStack(alignment: .center){
                        Image("CC-Logo").resizable().scaledToFill().frame(width: 50, height: 50)
                        Image("CC-BY").resizable().scaledToFill().frame(width: 50, height: 50)
                        Image("CC-NC").resizable().scaledToFill().frame(width: 50, height: 50)
                    }
                    Divider()
                    Text("For showing the images, the library URLImage by Dmytro Anokhin is used under the MIT-License.").font(.caption)
                }.padding().labelsHidden()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

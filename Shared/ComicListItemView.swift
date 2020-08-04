//
//  ComicListItemView.swift
//  XKCD
//
//  Created by Georg Meissner on 15.07.20.
//

import SwiftUI

struct ComicListItemView: View {
    var comic: XKCDComic
    @State var isfavourite: Bool
    
    var body: some View {
        HStack{
            Text(String(comic.num)).font(.headline)
            Spacer()
            Text(comic.title ?? "").font(.subheadline)
            Spacer()
            if isfavourite {Image(systemName: "star.fill")} else {Image(systemName: "star")}
        }
    }
}

struct ComicListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ComicListItemView(comic: XKCDComic(), isfavourite: false)
    }
}

//
//  ComicInfoView.swift
//  XKCD
//
//  Created by Georg Meissner on 03.08.20.
//

import SwiftUI

struct ComicInfoView: View {
    var comic: XKCDComic
    var body: some View {
        VStack(alignment:.leading){
            Text("Title: ").font(.title) + Text(String(comic.title!)).font(.title2)
            Text("Number: ").font(.title) + Text(String(comic.num)).font(.title2)
            Text("Date: ").font(.title) + Text(formatDate(date: comic.date!)).font(.title2)
            if comic.transcript != ""
            {
                Text("Transcript: ") + Text(comic.transcript!)
            }
            if comic.news != ""
            {
                Text("News: ") + Text(comic.news!)
            }
            if comic.link != ""
            {
                Text("Link: ") + Text(comic.link!)
            }
        }
    }
}

struct ComicInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ComicInfoView(comic: XKCDComic())
    }
}

//
//  ComicListView.swift
//  XKCD
//
//  Created by Georg Meissner on 15.07.20.
//

import SwiftUI

struct ComicListView: View {
    let store = PersistentStore.shared
    
    @FetchRequest(fetchRequest: PersistentStore.shared.fetchComics()) var xkcdcomics: FetchedResults<XKCDComic>
    
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showAbout: Bool = false
    @State private var selectedView: Int?
    
    var body: some View {
        NavigationView(){
            List{
                if xkcdcomics.isEmpty{
                    Button("Init"){self.store.addComic(context: managedObjectContext, number: 2341)}
                }
                ForEach(xkcdcomics, id: \.id) {comic in
                    NavigationLink(destination: ComicView(comic: comic, isfavourite: comic.favourite), tag: Int(comic.num), selection: $selectedView) {
                        ComicListItemView(comic: comic, isfavourite: comic.favourite)
                    }.navigationBarTitle("XKCD").navigationBarItems(trailing:
                                                                        HStack{
                                                                            Button(action: {
                                                                                self.selectedView = Int(xkcdcomics.randomElement()?.num ?? 1)
                                                                            }, label: {Image(systemName: "shuffle")})
                                                                            Button(action: {store.addAllComics(context: self.managedObjectContext)}, label: {Image(systemName: "arrow.counterclockwise.icloud")})
                                                                            
                                                                            Button(action: {self.showAbout = true}, label: {Image(systemName: "info.circle")})
                                                                                .sheet(isPresented: self.$showAbout, content: {AboutView()})
                                                                        }
                    )
                }
            }.animation(.default)
        }
    }
}

struct ComicListView_Previews: PreviewProvider {
    static var previews: some View {
        ComicListView()
    }
}

//
//  ComicView.swift
//  XKCD
//
//  Created by Georg Meissner on 02.03.20.
//  Copyright © 2020 Georg Meissner. All rights reserved.
//

import SwiftUI
import URLImage

struct ActivityView: UIViewControllerRepresentable {
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {
        
    }
}

struct XKCDImageView: View {
    var xkcdcomic: XKCDComic
    
    var body: some View {
        URLImage(xkcdcomic.img!, expireAfter: Date(timeIntervalSinceNow: 31_556_926.0),
                 placeholder: {
                    ProgressView($0) { progress in
                        ZStack {
                            if progress > 0.0 {
                                CircleProgressView(progress).stroke(lineWidth: 8.0)
                            }
                            else {
                                CircleActivityView().stroke(lineWidth: 50.0)
                            }
                        }
                    }
                    .frame(width: 50.0, height: 50.0)
                 },
                 content: {
                    $0.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        //.clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.all, 40.0)
                        .shadow(radius: 10.0)
                    //                        .scaleEffect(self.scale)
                 })
    }
}

struct ComicView: View {
    var comic: XKCDComic
    @State var isfavourite: Bool
    @State var showAlt: Bool = false
    @State var showInfo: Bool = false
    @State private var scale: CGFloat = 1.0
    @State private var showShareSheet: Bool = false
    
    var body: some View {
        VStack{
            Text("#\(comic.num) - \(comic.title ?? "")").font(.largeTitle)
            XKCDImageView(xkcdcomic: comic).onLongPressGesture {
                self.showAlt = true
            }
            .alert(isPresented: self.$showAlt) {
                Alert(title: Text("Alt Text"), message: Text(comic.alt!).font(.caption), dismissButton: .default(Text("OK!")))}
            //            .sheet(isPresented: self.$showAlt, content: {VStack{Text(comic.alt!)}})
            .gesture(MagnificationGesture().onChanged{value in
                self.scale = value
            })
        }//.navigationBarTitle(Text("#\(comic.num) - \(comic.title ?? "")"))
        .navigationBarItems(trailing: HStack{
            
            Button(action: {
                print("share not implemented")
            }){Image(systemName: "square.and.arrow.up")}
            
            Button(action: {
                self.isfavourite = !self.isfavourite
                self.comic.favourite = self.isfavourite
                self.comic.id = UUID()
            }) {if isfavourite {Image(systemName: "star.fill")} else {Image(systemName: "star")}}
            
            Button(action: {self.showInfo = true}){Image(systemName: "info.circle")}
                .sheet(isPresented: $showInfo, content: {ComicInfoView(comic: self.comic)})
        }
        )
    }
}

struct ComicView_Previews: PreviewProvider {
    static var previews: some View {
        ComicView(comic: XKCDComic(), isfavourite: false)
    }
}

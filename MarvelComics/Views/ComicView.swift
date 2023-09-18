//
//  ComicView.swift
//  MarvelComics
//
//  Created by Maliks on 17/09/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ComicView: View {
    
    @EnvironmentObject var homeData: HomeViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                if self.homeData.fetchedComics.isEmpty {
                    ProgressView()
                        .padding(.top, 30)
                }
                else {
                    VStack(spacing: 15) {
                        ForEach(self.homeData.fetchedComics) { comic in
                            ComicRowView(comic: comic)
                        }
                        
                        if self.homeData.offset == self.homeData.fetchedComics.count {
                            ProgressView()
                                .padding(.vertical)
                                .onAppear(perform: {
                                    self.homeData.fetchComics()
                                })
                        }
                        else {
                            GeometryReader { reader -> Color in
                                let minY = reader.frame(in: .global).minY
                                let height = UIScreen.main.bounds.height / 1.3
                                
                                if !self.homeData.fetchedComics.isEmpty && minY < height {
                                    DispatchQueue.main.async {
                                        self.homeData.offset = self.homeData.fetchedComics.count
                                    }
                                }
                                
                                return Color.clear
                            }
                            .frame(width: 20, height: 20)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Comics")
        }
        .onAppear(perform: {
            if self.homeData.fetchedComics.isEmpty {
                self.homeData.fetchComics()
            }
        })
    }
}

struct ComicRowView: View {
    
    var comic: Comic
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            WebImage(url: extractImage(data: comic.thumbnail))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(comic.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                if let description = comic.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                }
                
                HStack(spacing: 10) {
                    ForEach(comic.urls, id: \.self) { data in
                        NavigationLink(destination: WebView(url: extractURL(data: data)).navigationTitle(extractURLType(data: data)), label: {
                            Text(extractURLType(data: data))
                        })
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
    }
    
    func extractImage(data: [String: String]) -> URL {
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""

        return URL(string: "\(path).\(ext)")!
    }
    
    func extractURL(data: [String: String]) -> URL {
        let url = data["url"] ?? ""
        
        return URL(string: url)!
    }
    
    func extractURLType(data: [String: String]) -> String {
        let type = data["type"] ?? ""
        
        return type.capitalized
    }
}

struct ComicView_Previews: PreviewProvider {
    static var previews: some View {
        ComicView()
            .environmentObject(HomeViewModel())
    }
}

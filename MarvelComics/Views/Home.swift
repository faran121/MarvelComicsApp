//
//  Home.swift
//  MarvelComics
//
//  Created by Maliks on 16/09/2023.
//

import SwiftUI

struct Home: View {
    
    @StateObject var homeData = HomeViewModel()
    
    var body: some View {
        TabView {
            CharactersView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Characters")
                }
                .environmentObject(self.homeData)
            
            ComicView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Comics")
                }
                .environmentObject(self.homeData)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//
//  MainView.swift
//  Pokedex
//
//  Created by Victor Ulloa on 2024-03-30.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Search")
                }
        }
    }
}

#Preview {
    MainView()
}

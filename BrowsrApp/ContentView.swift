//
//  ContentView.swift
//  BrowsrApp
//
//  Created by BRUNO VASCONCELOS on 28/01/2023.
//

import SwiftUI
import BrowsrFramework

struct ContentView: View {
        // MARK: - Properties
        @ObservedObject var favorites = Favorites()
        
        @EnvironmentObject var favoritesObj: Favorites
        
        var organization: Item
        
        // MARK: - Body
        var body: some View {
            HStack(alignment: .center, spacing: 0) {
                AsyncImage(url: URL(string: organization.avatarURL),
                           content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                },
                           placeholder: {
                    ProgressView()
                })
                
                .frame(width: 40.0, height: 40.0, alignment: .center)
                .padding([.vertical, .leading], 10)
                .padding(.trailing, 10)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack (alignment: .top){
                        Text("\(organization.login)")
                            .padding(.trailing)
                    }
                }
                .foregroundColor(.yellow)
                
                Spacer()
                if favorites.contains(organization) {
                    Image(systemName: "checkmark.rectangle.fill")
                        .resizable()
                        .foregroundColor(.yellow)
                        .frame(width: 20, height: 20)
                        .padding(.trailing)
                } else {
                    Image(systemName: "checkmark.rectangle")
                        .resizable()
                        .foregroundColor(.yellow)
                        .frame(width: 20, height: 20)
                        .padding(.trailing)
                }
            }
            .environmentObject(favorites)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
}


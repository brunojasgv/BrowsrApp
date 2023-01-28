//
//  OrganizationsListView.swift
//  BrowsrApp
//
//  Created by BRUNO VASCONCELOS on 28/01/2023.
//

import SwiftUI

struct OrganizationsListView: View {
    // MARK: - Properties
    @StateObject var viewModel = ViewModel()
    @StateObject var favorites = Favorites()
    
    @State var sortSelection: String = "followers"
    @State var searchString: String = ""
    
    @Environment(\.isSearching) var isSearching
    @EnvironmentObject var favoritesObj: Favorites
    
    let sorting = ["followers", "repositories", "joined", "favorites"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    
                    Section {
                        Picker("", selection: $sortSelection) {
                            ForEach(sorting, id: \.self) { sort in
                                Text(sort)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.organizations.indices, id: \.self) { index in
                                ContentView(organization: viewModel.organizations[index])
                                    .onAppear() {
                                        if !isSearching && searchString.isEmpty && sortSelection != DEFAULT_KEY {
                                            viewModel.loadMoreOrganizations(index: index, sortType: sortSelection)
                                        }
                                    }
                                    .onTapGesture {
                                        if favorites.contains(viewModel.organizations[index]) {
                                            favorites.remove(viewModel.organizations[index])
                                        } else {
                                            favorites.add(viewModel.organizations[index])
                                        }
                                    }
                            }
                        }
                    }
                    .searchable(text: $searchString, prompt: "Organization...", suggestions: {
                        
                    })
                    .onChange(of: searchString) { newString in
                        if newString.isEmpty {
                            viewModel.sortOrganization(sortSelection)
                            sortSelection = sorting[0]
                        }
                    }
                    .onChange(of: sortSelection) { sort in
                        searchString = ""
                        if sort == DEFAULT_KEY {
                            viewModel.getFavorites()
                        } else {
                            viewModel.sortOrganization(sort)
                        }
                    }
                    .onSubmit(of: .search) {
                        viewModel.searchOrganization(_: searchString)
                    }
                    .onAppear {
                        viewModel.getOrganizations()
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(x: 2, y: 2, anchor: .center)
                }
            }
        }
        .environmentObject(favorites)
    }
}

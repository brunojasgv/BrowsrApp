//
//  ViewModel.swift
//  BrowsrApp
//
//  Created by BRUNO VASCONCELOS on 28/01/2023.
//

import Foundation
import BrowsrFramework

class ViewModel: ObservableObject {
    
    // MARK: - Properties
    private var page: Int = 1
    private var totalPages = 0
    private let browsrAPI = Browsr()
    var favorites: [Item] = []
    let defaults = UserDefaults.standard
    
    @Published var organizations: [Item] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Methods
    @MainActor
    func getOrganizations() {
        isLoading = true
        
        Task {
            do {
                self.organizations = try await self.browsrAPI.fetchOrgs(page: self.page)
            } catch let error {
                debugPrint("getOrganizations failed with error \(error)")
            }
            self.isLoading = false
        }.cancel()
    }
    
    // MARK: - Load more orgs
    @MainActor
    func loadMoreOrganizations(index: Int, sortType: String) {
        let limitIndex = self.organizations.index(self.organizations.endIndex, offsetBy: -1)
        if limitIndex == index, (page + 1) <= totalPages {
            page += 1
            sortOrganization(sortType)
        }
    }
    
    // MARK: - Search for an organization by name
    @MainActor
    func searchOrganization(_ name: String) {
        self.isLoading = true
        
        Task {
            do {
                self.organizations = try await self.browsrAPI.searchOrgs(name: name.lowercased())
            } catch let error {
                debugPrint("searchOrganization failed with error \(error)")
            }
            self.isLoading = false
        }.cancel()

    }
    
    // MARK: - Sort organizations
    @MainActor
    func sortOrganization(_ sortType: String) {
        self.isLoading = true
        
        Task {
            do {
                self.organizations = try await self.browsrAPI.sortOrgs(page: self.page, sortType: sortType)
            } catch let error {
                debugPrint("sortOrganization failed with error \(error)")
            }
            self.isLoading = false
        }.cancel()
  
    }
    
    func getFavorites() {
        let decoder = JSONDecoder()
        if let data = defaults.value(forKey: DEFAULT_KEY) as? Data {
            let taskData = try? decoder.decode([Item].self, from: data)
            self.organizations = taskData ?? []
        } else {
            self.organizations = []
        }
    }
}

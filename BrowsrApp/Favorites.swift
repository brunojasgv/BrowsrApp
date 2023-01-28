//
//  Favorites.swift
//  BrowsrApp
//
//  Created by BRUNO VASCONCELOS on 28/01/2023.
//

import Foundation
import BrowsrFramework

public let DEFAULT_KEY = "Favorites"

class Favorites: ObservableObject {
    
    // MARK: - Properties
    private var organizations: [Item] = []
    
    let defaults = UserDefaults.standard
    
    var emptyString: String = ""
    
    // MARK: - Init()
    init() {
        let decoder = JSONDecoder()
        if let data = defaults.value(forKey:  DEFAULT_KEY) as? Data {
            let taskData = try? decoder.decode([Item].self, from: data)
            self.organizations = taskData ?? []
        } else {
            self.organizations = []
            self.emptyString = ""
        }
    }
    
    // MARK: - Methods
    func contains(_ organization: Item) -> Bool {
        return organizations.contains(organization)
    }
    
    func add(_ organization: Item) {
        objectWillChange.send()
        organizations.append(organization)
        save()
    }
    
    func remove(_ organization: Item) {
        objectWillChange.send()
        organizations.removeAll{ $0 == organization}
        save()
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(organizations) {
            defaults.set(encoded, forKey: DEFAULT_KEY)
        }
    }
}

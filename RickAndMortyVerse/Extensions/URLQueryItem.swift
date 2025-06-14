import Foundation

extension URLQueryItem {
    static func page(_ page: String) -> URLQueryItem {
        URLQueryItem(name: "page", value: page)
    }
    
    static func name(_ name: String) -> URLQueryItem {
        URLQueryItem(name: "name", value: name)
    }
    
    static func gender(_ gender: Gender) -> URLQueryItem {
        URLQueryItem(name: "gender", value: gender.rawValue)
    }
    
    static func status(_ status: Status) -> URLQueryItem {
        URLQueryItem(name: "status", value: status.rawValue)
    }
    
    static func species(_ species: Species) -> URLQueryItem {
        URLQueryItem(name: "species", value: species.rawValue)
    }
    
    static func queryItemsByFilters(_ filters: CharacterFiltersModel) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        if let name = filters.name {
            queryItems.append(.name(name))
        }
        if let gender = filters.gender {
            queryItems.append(.gender(gender))
        }
        if let status = filters.status {
            queryItems.append(.status(status))
        }
        if let species = filters.species {
            queryItems.append(.species(species))
        }
        
        return queryItems
    }

}

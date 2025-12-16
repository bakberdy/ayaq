
import Foundation

extension URL {
    
    func appending(_ queryItem: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        var queryItems = urlComponents.queryItems ?? []
        let newQueryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(newQueryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url ?? self
    }
    
    func appendingQueryItems(_ items: [String: String]) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        var queryItems = urlComponents.queryItems ?? []
        items.forEach { key, value in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url ?? self
    }
    
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return nil
        }
        var parameters = [String: String]()
        queryItems.forEach { item in
            parameters[item.name] = item.value
        }
        return parameters
    }
    
    func valueOf(_ queryParameter: String) -> String? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return nil
        }
        return queryItems.first { $0.name == queryParameter }?.value
    }
}


//
//  NetworkManager.swift
//  Pokedex-v2
//
//  Created by Victor Ulloa on 2024-03-31.
//

import Foundation

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum Path : String {
    case pokemons = "/api/v2/pokemon"
}

protocol NetworkManagerProtocol {
    func getPokemonList(offset: Int, limit: Int, completionHandler: @escaping (PokemonListResponse) -> Void)
}

struct NetworkManager: NetworkManagerProtocol {
    
    static let instance = NetworkManager()
    
    static let baseUrl = "pokeapi.co"
    
    func getPokemonList(offset: Int, limit: Int, completionHandler: @escaping (PokemonListResponse) -> Void) {
        
        let queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        guard let url = buildUrl(path: .pokemons, queryItems: queryItems) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            do {
                let locationsResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                completionHandler(locationsResponse)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
    }
    
    private func buildUrl(path: Path, queryItems: [URLQueryItem]) -> URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = NetworkManager.baseUrl
        components.path = path.rawValue
        components.queryItems = queryItems
        return components.url
    }
    
}


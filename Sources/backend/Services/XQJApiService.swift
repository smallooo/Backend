//
//  File.swift
//  
//
//  Created by Dongming He on 2023/2/14.
//

import Foundation
import Combine

struct User: Codable {
    let code: Int
    let msg: String
    let data: String
}

public struct XQJApiService {
    public static let BASE_URL = URL(string: "http://127.0.0.1:8000")!
    private static var cache: [String: Codable] = [:]
    
    public enum Endpoint {
        case villagers
        case villagerIcon(id: Int)
        case villagerImage(id: Int)
        case songs
        case songsImage(id: Int)
        case music(id: Int)
        
        public func path() -> String {
            switch self {
            case .villagers:
                return "test"
            case let .villagerIcon(id):
                return "icons/villagers/\(id)"
            case let .villagerImage(id):
                return "images/villagers/\(id)"
            case .songs:
                return "songs"
            case let .songsImage(id):
                return "images/songs/\(id)"
            case let .music(id):
                return "music/\(id)"
            }
        }
        
        public func url() -> URL {
            XQJApiService.BASE_URL.appendingPathComponent(path())
        }
    }
    
    private static let decoder = JSONDecoder()
    
    public static func makeURL(endpoint: Endpoint) -> URL {
        let component = URLComponents(url: BASE_URL.appendingPathComponent(endpoint.path()),
                                      resolvingAgainstBaseURL: false)!
        return component.url!
    }
    
    public static func fetch(endpoint: Endpoint) -> String  {
//        if let cached = Self.cache[endpoint.path()] as? T {
//            return Just(cached)
//                .setFailureType(to: APIError.self)
//                .eraseToAnyPublisher()
//        }
        let url = URL(string: "http://127.0.0.1:8000/test")!
        let pub = URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: User.self, decoder: JSONDecoder())
            
        
        
        return ""
    }
}

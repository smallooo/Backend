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
        case login
        case villagers
        case villagerIcon(id: Int)
        case villagerImage(id: Int)
        case songs
        case songsImage(id: Int)
        case music(id: Int)
        
        public func path() -> String {
            switch self {
            case let .login:
                return "auth"
            case .villagers:
                return "villagers"
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
    
    public static func makeURL(endpoint: Endpoint, queryList :[URLQueryItem] = []) -> URL {
        var component = URLComponents(url: BASE_URL.appendingPathComponent(endpoint.path()), resolvingAgainstBaseURL: false)!
        if(!queryList.isEmpty){ component.queryItems = queryList }
        return component.url!
    }
    
 
    public static func fetch<T: Codable>(endpoint: Endpoint, queryList : [URLQueryItem] = [] ) -> AnyPublisher<T ,APIError>  {
        //请求缓存
//        if let cached = Self.cache[endpoint.path()] as? T {
//            return Just(cached)
//                .setFailureType(to: APIError.self)
//                .eraseToAnyPublisher()
//        }
        var request = URLRequest(url: makeURL(endpoint: endpoint, queryList: queryList))
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "token")
        
        
        
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ data, response in
                return try APIError.processResponse(data: data, response: response)
        }
        .decode(type: T.self, decoder: Self.decoder)
        .mapError{
            APIError.parseError(reason: $0.localizedDescription)
            
        }
        .map({ result in
            Self.cache[endpoint.path()] = result
            return result
        })
        .eraseToAnyPublisher()
    }
}

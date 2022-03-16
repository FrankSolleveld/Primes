//
//  WolframAlpha.swift
//  Counter
//
//  Created by Frank Solleveld on 10/03/2022.
//

import Foundation
import ComposableArchitecture

// MARK: - Wolfram Alpha
private let wolframAlphaApiKey = "6H69Q3-828TKQJ4EP"

struct WolframAlphaResult: Decodable {
    let queryresult: QueryResult
    
    struct QueryResult: Decodable {
        let pods: [Pod]
        
        struct Pod: Decodable {
            let primary: Bool?
            let subpods: [SubPod]
            
            struct SubPod: Decodable {
                let plaintext: String
            }
        }
    }
}

func nthPrime(_ n: Int) -> Effect<Int?> {
    return wolframAlpha(query: "prime \(n)").map { result in
        result
            .flatMap {
                $0.queryresult
                    .pods
                    .first(where: { $0.primary == .some(true) })?
                    .subpods
                    .first?
                    .plaintext
            }
            .flatMap(Int.init)
    }
}

func wolframAlpha(query: String) -> Effect<WolframAlphaResult?> {
    var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
    components.queryItems = [
        URLQueryItem(name: "input", value: query),
        URLQueryItem(name: "format", value: "plaintext"),
        URLQueryItem(name: "output", value: "JSON"),
        URLQueryItem(name: "appid", value: wolframAlphaApiKey),
    ]
    
    return dataTask(with: components.url(relativeTo: nil)!)
        .decode(as: WolframAlphaResult.self)
}

func dataTask(with url: URL) -> Effect<(Data?, URLResponse?, Error?)> {
    return Effect { callback in
        URLSession.shared.dataTask(with: url) { data, response, error in
            callback((data, response, error))
        }
        .resume()
    }
}

extension Effect where A == (Data?, URLResponse?, Error?) {
    func decode<M: Decodable>(as type: M.Type) -> Effect<M?> {
        return self.map { data, _, _ in
            data
                .flatMap { try? JSONDecoder().decode(M.self, from: $0) }
        }
    }
}

extension Effect {
    func receive(on queue: DispatchQueue) -> Effect {
        return Effect { callback in
            self.run { a in
                queue.async {
                    callback(a)
                }
            }
        }
    }
}

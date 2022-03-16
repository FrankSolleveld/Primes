//
//  Effects.swift
//  ComposableArchitecture
//
//  Created by Frank Solleveld on 16/03/2022.
//

//import Foundation
//
//public func dataTask(with url: URL) -> Effect<(Data?, URLResponse?, Error?)> {
//    return Effect { callback in
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            callback((data, response, error))
//        }
//        .resume()
//    }
//}
//
//public extension Effect where A == (Data?, URLResponse?, Error?) {
//    func decode<M: Decodable>(as type: M.Type) -> Effect<M?> {
//        return self.map { data, _, _ in
//            data
//                .flatMap { try? JSONDecoder().decode(M.self, from: $0) }
//        }
//    }
//}
//
//public extension Effect {
//    func receive(on queue: DispatchQueue) -> Effect {
//        return Effect { callback in
//            self.run { a in
//                queue.async {
//                    callback(a)
//                }
//            }
//        }
//    }
//}

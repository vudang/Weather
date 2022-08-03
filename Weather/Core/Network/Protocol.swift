//
//  Protocol.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public protocol APIRequestProtocol {
    var path: String { get }
    var params: [String: Any]? { get }
    var header: [String: String]? { get }
}

public protocol NetworkProtocol {
     static func request(using router: APIRequestProtocol, method m: HTTPMethod, encoding e: ParameterEncoding) -> Observable<(HTTPURLResponse, Data)>
}

public struct Response<T: Decodable> {
    public let httpResponse: HTTPURLResponse
    public let response: T
}

public extension NetworkProtocol {
    static func customResponse<E: Decodable>(using router: APIRequestProtocol,
                                                      method m: HTTPMethod = .get,
                                                      encoding e: ParameterEncoding = URLEncoding.default,
                                                      transform: @escaping (Data) throws -> E) -> Observable<(HTTPURLResponse, E)>
    {
        return self.request(using: router, method: m, encoding: e)
            .map { ($0.0, try transform($0.1)) }
    }
    
    static func requestDTO<E: Decodable>(using router: APIRequestProtocol,
                                         method m: HTTPMethod = .get,
                                         encoding e: ParameterEncoding = URLEncoding.default) -> Observable<(HTTPURLResponse, E)> {
        return self.customResponse(using: router,
                                   method: m,
                                   encoding: e,
                                   transform: { try E.toModel(from: $0) })
    }
}

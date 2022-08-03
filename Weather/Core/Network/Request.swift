//
//  Request.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

public struct Requester: NetworkProtocol {
    private static let apiTimeout: Int = 240
    private static let manager = Session()
    static let kReponseStatusCode = "kReponseStatusCode"
    
    public static func request(using router: APIRequestProtocol,
                        method m: HTTPMethod = .get,
                        encoding e: ParameterEncoding = URLEncoding.default) -> Observable<(HTTPURLResponse, Data)> {
        let p = router.path
        let params = router.params
        var header: HTTPHeaders?
        if let h = router.header {
            header = HTTPHeaders(h)
        }
        return Observable<(HTTPURLResponse, Data)>.create({ (s) -> Disposable in
            let task = manager.request(p, method: m, parameters: params, encoding: e, headers: header)
            task.responseData { data in
                let result = data.result
                
                guard let response = data.response else {
                    let e = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil)
                    s.onError(e)
                    return
                }
                
                switch result {
                case .success(let value):
                    s.onNext((response, value))
                    s.onCompleted()
                case .failure(let e):
                    s.onError(e)
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        })
        .observe(on: SerialDispatchQueueScheduler(qos: .background))
        .timeout(RxTimeInterval.seconds(apiTimeout), scheduler: SerialDispatchQueueScheduler(qos: .background))
    }
}

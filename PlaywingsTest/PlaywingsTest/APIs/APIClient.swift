//
//  APIClient.swift
//  PlaywingsTest
//
//  Created by JuYoung choi on 2018. 4. 17..
//  Copyright © 2018년 JuYoung choi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// 네트워크 상수
class NetworkConstants {
    
    /// MainDomain
    static let mainDomain = "https://api.punkapi.com/v2"
    /// 타임아웃
    static let NetworkTimeout: TimeInterval = 5
}

enum APIRouter: URLRequestConvertible {
    
    case beerList(Parameters)
    case login(Parameters)
    
    func asURLRequest() throws -> URLRequest {
        
        // API 정보
        let result: (path: String, method: HTTPMethod, parameters: Parameters?) = {
            
            switch self {
            case .beerList(let parameters) :
                
                return ("/beers", .get, parameters)
            default :
                return ("/openapi/app/v2/bootstrap", .get, nil)
            }
        }()
        
        let url = try NetworkConstants.mainDomain.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        debugPrint("url.appendingPathComponent(result.path) : \(url.appendingPathComponent(result.path))")
        urlRequest.httpMethod = result.method.rawValue
        
        return try URLEncoding.default.encode(urlRequest, with: self.makeParameterWithDefault(result.parameters))
    }
    
    /// 기본 파라미터
    func makeParameterWithDefault(_ parameters: Parameters?) -> Parameters {
        
        var defaultParameters = Parameters()

        defaultParameters["scope"] = "basic"
        
        return defaultParameters
    }
    
}




/// 통신 담당 클래스
class APIClient {

    static let shared = APIClient()
    
    var sessionManager: SessionManager!
    
    init() {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        // 타임아웃 5초
        configuration.timeoutIntervalForRequest  = NetworkConstants.NetworkTimeout
        configuration.timeoutIntervalForResource = NetworkConstants.NetworkTimeout
        
        self.sessionManager = SessionManager(configuration: configuration)
    }
    
    public func requestJson(parameter: Parameters, completion: @escaping (APIResult<JSON>) -> Void) {
        
        self.requestJSON(APIRouter.beerList(parameter)) { (json, error) in
            
            
        }
    }
    
    /// JSON 응답 요청
    ///
    /// - Parameters:
    ///   - urlRequest: 통신에 필요한 request객체
    ///   - completion: 완료시 리턴하는 콜백
    func requestJSON(_ urlRequest: URLRequestConvertible, completion: @escaping APIResultHandler) {
        
        self.sessionManager.request(urlRequest).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if CommonConstants.isDebug {
                    
                    if let urlRequest = urlRequest.urlRequest {
                        
                        debugPrint("[\(urlRequest.httpMethod ?? "")] \(urlRequest)")
                        if let httpBody = urlRequest.httpBody, let body = httpBody.utf8String {
                            
                            debugPrint("[PARAMS] \(body)")
                        }
                    }
                    
                    debugPrint("[response] \(json)")
                }
                completion(json, nil)
            case .failure(let error):
                
                let nsError = error as NSError
                debugPrint("Error code : \(nsError.code)\nError description : \(nsError.description)")
                completion(nil, error)
            }
        }
    }
}

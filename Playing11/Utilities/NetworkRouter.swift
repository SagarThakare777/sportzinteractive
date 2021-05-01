//
//  NetworkRouter.swift
//  Playing11
//
//  Created by SAGAR THAKARE on 29/04/21.
//

import Alamofire
import SystemConfiguration


//MARK:- Checking Connected to the Network
func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}

//MARK:- API Request With Response Manager
extension DataRequest {
    @discardableResult func responseTwoDecodable<T: Decodable>(queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated), of t: T.Type, completionHandler: @escaping (Result<T, APIError>) -> Void) -> Self {
        return response(queue: .main, responseSerializer: TwoDecodableResponseSerializer<T>()) { response in
            switch response.result {
            case .success(let result):
                completionHandler(result)
            case .failure(let error):
                completionHandler(.failure(APIError(message: "Other error", code: "other", args: [error.localizedDescription])))
                }
            }
        }
    }

final class TwoDecodableResponseSerializer<T: Decodable>: ResponseSerializer {

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()


   private lazy var successSerializer = DecodableResponseSerializer<T>(decoder: decoder)
   private lazy var errorSerializer = DecodableResponseSerializer<APIError>(decoder: decoder)


   public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Result<T, APIError> {


       guard error == nil else { return .failure(APIError(message: "Unknown error", code: "unknown", args: [])) }


        guard let response = response else { return .failure(APIError(message: "Empty response", code: "empty_response", args: [])) }


        do {
            if response.statusCode < 200 || response.statusCode >= 300 {
                let result = try errorSerializer.serialize(request: request, response: response, data: data, error: nil)
                return .failure(result)
                } else {
                    let result = try successSerializer.serialize(request: request, response: response, data: data, error: nil)
                    return .success(result)
                }
            } catch(let err) {
                return .failure(APIError(message: "Could not serialize body", code: "unserializable_body", args: [String(data: data!, encoding: .utf8)!, err.localizedDescription]))
                }}
}


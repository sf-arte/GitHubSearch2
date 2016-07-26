//
//  GitHub.swift
//  GitHubSearch2
//
//

import Foundation

import AFNetworking

public enum HTTPMethod {
    case Get
}

public protocol JSONDecodable {
    init(JSON: JSONObject) throws
}

public protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    associatedtype ResponseType: JSONDecodable
}

public struct Parameters: DictionaryLiteralConvertible {
    public private(set) var dictionary: [String: AnyObject] = [:]
    public typealias key = String
    public typealias Value = AnyObject?
    
    public init(dictionaryLiteral elements: (Parameters.Key, Parameters.Value)...) {
        for case let (key, value?) in elements {
            dictionary[key] = value
        }
    }
}

public class GitHubAPI {
    private let HTTPSessionManager: AFHTTPSessionManager = {
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: "https://api.github.com/"))
        manager.requestSerializer.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        return manager
        }()

    public init(){
    }

    public func request<Endpoint: APIEndpoint>(endpoint: Endpoint, handler: (task: NSURLSessionDataTask, response: Endpoint.ResponseType?, error: ErrorType?) -> Void) {
        let success = { (task: NSURLSessionDataTask!, response: AnyObject!) -> Void in
            if let JSON = response as? JSONObject {
                do {
                    let response = try Endpoint.ResponseType(JSON: JSON)
                    handler(task: task, response: response, error: nil)
                } catch {
                    handler(task: task, response: nil, error: error)
                }
            } else {
                handler(task: task, response: nil, error: APIError.UnexpectedResponse)
            }
        }
        let failure = { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
            handler(task: task, response: nil, error: error)
        }

        switch endpoint.method {
        case .Get:
            HTTPSessionManager.GET(endpoint.path, parameters: endpoint.parameters.dictionary, success: success, failure: failure)
        }
    }
}

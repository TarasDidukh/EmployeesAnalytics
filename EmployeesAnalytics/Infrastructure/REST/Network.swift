//
//  Network.swift
//  EmployeesAnalytics
//
//  Created by Taras Didukh on 5/19/18.
//  Copyright © 2018 Taras Didukh. All rights reserved.
//
import ReactiveSwift
import Foundation
import Alamofire
import Result

public final class Network : Networking {
    var withApiToken: Bool
    var contentType: ContentType
    
    private let queue = DispatchQueue(label: "EmployeesAnalytics.Infrastructure.REST.Network.Queue", attributes: [])
    
    init() {
        self.withApiToken = true
        self.contentType = ContentType.StringContent
    }
    
    private func InitAuth() -> (String, String)?
    {
        if withApiToken, let token = UserDefaults.standard.string(forKey: StorageKey.ApiAccessToken.rawValue) {
            return ("Authorization", "bearer " + token)
        }
        return nil
    }
    
    private func adaptHeaders(_ urlRequest: URLRequest) -> URLRequest
    {
        var adaptedUrlRequst = urlRequest
        if let authHeader = InitAuth() {
            adaptedUrlRequst.addValue(authHeader.1, forHTTPHeaderField: authHeader.0)
        }
        if contentType == ContentType.EncodedContent {
            adaptedUrlRequst.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        } else if contentType == ContentType.StringContent {
            adaptedUrlRequst.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        }
        self.withApiToken = true
        self.contentType = ContentType.StringContent
        
        return adaptedUrlRequst
    }
    
    func post<TRequest: Codable, TResponse: Codable, TError: ErrorProvider>(_ url: String, data: TRequest) -> SignalProducer<TResponse, TError> {
        return SignalProducer { observer, disposable in
            let encoder = JSONEncoder()
            let jsonData = try! encoder.encode(data)
            if let url = URL(string: url) {
                var request = URLRequest(url: url)
                request = self.adaptHeaders(request)
                request.httpMethod = HTTPMethod.post.rawValue
                request.httpBody = jsonData
                Alamofire.request(request).responseJSON(queue: self.queue) { response in
                    self.handleResult(observer, response)
                }
            }
        }
    }
    
    func post<TResponse : Codable, TError: ErrorProvider>(_ url: String, parameters: [String: String]?) -> SignalProducer<TResponse, TError> {
        return SignalProducer { observer, disposable in
            var headers: [String: String]? = nil
            if let authHeader = self.InitAuth() {
                headers = [authHeader.0 : authHeader.1]
            }

            Alamofire.request(url, method: .post, parameters: parameters, headers: headers)
                .responseJSON(queue: self.queue){ response in
                self.handleResult(observer, response)
            }
        }
    }
    
    func get<TResponse : Codable, TError: ErrorProvider>(_ url: String, parameters: [String: String]?) -> SignalProducer<TResponse, TError> {
        return SignalProducer { observer, disposable in
            var headers: [String: String]? = nil
            if let authHeader = self.InitAuth() {
                headers = [authHeader.0 : authHeader.1]
            }

            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers)
                .responseJSON(queue: self.queue){ response in
                    self.handleResult(observer, response)
            }
        }
    }
    
    func uploadImage<TResponse: Codable, TError: ErrorProvider>(_ url: String, data: Data ) -> SignalProducer<TResponse, TError> {
        return SignalProducer { observer, disposable in
            var headers: [String: String]? = nil
            if let authHeader = self.InitAuth() {
                headers = [authHeader.0 : authHeader.1]
            }
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(data, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
            },to: url, headers: headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        self.handleResult(observer, response)
                    }
                    
                case .failure(let error):
                    observer.send(error: TError(error: error as NSError))
                }
            }
        }
    }
    
    func handleResult<TResponse: Codable, TError: ErrorProvider>(_ observer: Signal<TResponse, TError>.Observer, _ response: DataResponse<Any>) {
        switch response.result {
        case .success:
            do {
                let result = try JSONDecoder().decode(TResponse.self, from: response.data!)
                observer.send(value: result)
            }catch {
                do {
                    let error = try JSONDecoder().decode(TError.self, from: response.data!)
                    observer.send(error: error)
                } catch {
                    observer.send(error: TError())
                }
            }
            observer.sendCompleted()
        case .failure(let error):
            observer.send(error: TError(error: error as NSError))
        }
    }
    
    
}

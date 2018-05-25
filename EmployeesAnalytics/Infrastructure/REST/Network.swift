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
        self.contentType = ContentType.EncodedContent
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
            adaptedUrlRequst.addValue(authHeader.0, forHTTPHeaderField: authHeader.1)
        }
//        if contentType == ContentType.EncodedContent {
//            adaptedUrlRequst.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        } else if contentType == ContentType.StringContent {
//            adaptedUrlRequst.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        }
        self.withApiToken = true
        self.contentType = ContentType.EncodedContent
        
        return adaptedUrlRequst
    }
    
    func post<TRequest: Codable, TResponse: Codable, TError: ErrorProvider>(_ url: String, data: TRequest) -> SignalProducer<TResponse, TError> {
        return SignalProducer { observer, disposable in
            let encoder = JSONEncoder()
            let jsonData = try! encoder.encode(data)
            
            if let url = URL(string: url) {
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request = self.adaptHeaders(request)
                request.httpBody = jsonData
                request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                Alamofire.request(request).responseString(queue: self.queue) { response in
                    //self.handleResult(observer, response)
                    do {
                        let test1 = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        print(test1)
                    } catch let myJSONError {
                        print(myJSONError)
                    }
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
    
    func post(_ url: String, parameters: [String: String]?) -> SignalProducer<(), NoError> {
        return SignalProducer { observer, disposable in
            var headers: [String: String]? = nil
            if let authHeader = self.InitAuth() {
                headers = [authHeader.0 : authHeader.1]
            }
            Alamofire.request(url, method: .post, parameters: parameters, headers: headers)
                .response(queue: self.queue){ response in
                    observer.sendCompleted()
            }
        }
    }
    
    func get<TResponse : Codable, TError: ErrorProvider>(_ url: String, parameters: [String: String]?) -> SignalProducer<TResponse, TError> {
        return SignalProducer { observer, disposable in
            var headers: [String: String]? = nil
            if let authHeader = self.InitAuth() {
                headers = [authHeader.0 : authHeader.1]
            }
            
            Alamofire.request(url, method: .get, parameters: parameters, headers: headers)
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
                do {
                    let test1 = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    print(test1)
                } catch let myJSONError {
                    print(myJSONError)
                }
                
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

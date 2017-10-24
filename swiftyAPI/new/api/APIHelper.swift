//
//  APIHelper.swift
//  new
//
//  Created by vandana on 10/24/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Alamofire

enum HTTP_METHOD {
    case GET,
    POST
}

enum APIHelperName : Int {
    case APIHelperSignup = 1,
    APIHelperVerify = 2,
    APIHelperLogin = 3
}

protocol APIHelperDelegate {
    func APIHelperSuccess(_ resposeObject: AnyObject, name: APIHelperName)
    func APIHelperFailed(_ errorObject:String, name: APIHelperName)
}


class APIHelper: NSObject {
    var delegateObject : APIHelperDelegate!
    
    // Shared Object Creation
    static let sharedInstance = APIHelper()
    
    // Make API Request WITHOUT Header Parameters
    func requestWithURL(_ httpMethod: HTTP_METHOD, urlString: String, delegate: APIHelperDelegate, name: APIHelperName) {
        self.delegateObject = delegate
        let methodOfRequest : HTTPMethod = (httpMethod == HTTP_METHOD.GET) ? HTTPMethod.get : HTTPMethod.post
        let queue = DispatchQueue(label: "com.shiponk.iTunes", attributes: DispatchQueue.Attributes.concurrent)
        let request = Alamofire.request(urlString, method: methodOfRequest, parameters: nil, encoding: JSONEncoding.default)
        request.responseJSON(queue: queue,
                             options: JSONSerialization.ReadingOptions.allowFragments) {
                                (response : DataResponse<Any>) in
                                // You are now running on the concurrent `queue` you created earlier.
                                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                                
                                // To update anything on the main thread, just jump back on like so.
                                DispatchQueue.main.async {
                                    print("Am I back on the main thread: \(Thread.isMainThread)")
                                    if (response.result.isSuccess) {
                                        self.delegateObject.APIHelperSuccess(response.result.value! as AnyObject, name: name)
                                    }
                                    else if (response.result.isFailure) {
                                        self.delegateObject.APIHelperFailed((response.result.error?.localizedDescription)!, name: name)
                                    }
                                }
        }
        
    }
    
    // Make API Request WITH Parameters
    func requestWithUrlAndParameters(_ httpMethod: HTTP_METHOD, urlString: String, parameters: [String : AnyObject], delegate: APIHelperDelegate, name: APIHelperName) {
        self.delegateObject = delegate
        let methodOfRequest : HTTPMethod = (httpMethod == HTTP_METHOD.GET) ? HTTPMethod.get : HTTPMethod.post
        let queue = DispatchQueue(label: "com.shiponk.iTunes", attributes: DispatchQueue.Attributes.concurrent)
        let request = Alamofire.request(urlString, method: methodOfRequest, parameters: parameters, encoding: JSONEncoding.default)
        //let request = Alamofire.request(urlString)
        request.responseJSON(queue: queue,
                             options: JSONSerialization.ReadingOptions.allowFragments) {
                                (response : DataResponse<Any>) in
                                // You are now running on the concurrent `queue` you created earlier.
                                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                                // To update anything on the main thread, just jump back on like so.
                                DispatchQueue.main.async {
                                    //print(response.data as! NSData)
                                    print("Am I back on the main thread: \(Thread.isMainThread)")
                                    if (response.result.isSuccess) {
                                        self.delegateObject.APIHelperSuccess(response.result.value! as AnyObject, name: name)
                                    }
                                    else if (response.result.isFailure) {
                                        self.delegateObject.APIHelperFailed((response.result.error?.localizedDescription)!, name: name)
                                    }
                                }
        }
    }
    
    // Make API Request WITH Header
    func requestWithUrlAndHeader(_ httpMethod: HTTP_METHOD, urlString: String, header: [String : String], delegate: APIHelperDelegate, name: APIHelperName) {
        self.delegateObject = delegate
        let methodOfRequest : HTTPMethod = (httpMethod == HTTP_METHOD.GET) ? HTTPMethod.get : HTTPMethod.post
        
        let queue = DispatchQueue(label: "com.shiponk.manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        
        let request = Alamofire.request(urlString, method: methodOfRequest, parameters: nil, encoding: JSONEncoding.default, headers: header)
        
        //        let request = Alamofire.request(methodOfRequest, urlString, headers: header)
        request.responseJSON(queue: queue,
                             options: JSONSerialization.ReadingOptions.allowFragments) {
                                (response : DataResponse<Any>) in
                                // You are now running on the concurrent `queue` you created earlier.
                                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                                
                                // To update anything on the main thread, just jump back on like so.
                                DispatchQueue.main.async {
                                    print("Am I back on the main thread: \(Thread.isMainThread)")
                                    if (response.result.isSuccess) {
                                        self.delegateObject.APIHelperSuccess(response.result.value! as AnyObject, name: name)
                                    }
                                    else if (response.result.isFailure) {
                                        self.delegateObject.APIHelperFailed((response.result.error?.localizedDescription)!, name: name)
                                    }
                                }
        }
    }
    //MARK:- API Request WITH All Parameters
    func requestWithUrlAndAllParameters(_ httpMethod: HTTP_METHOD, urlString: String, parameters: [String : AnyObject],image: UIImage, delegate: APIHelperDelegate, name: APIHelperName) {
        
        self.delegateObject = delegate
        let _ : HTTPMethod = (httpMethod == HTTP_METHOD.GET) ? HTTPMethod.get : HTTPMethod.post
        var imageData : Data!
        imageData = UIImagePNGRepresentation(image)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for element in parameters.keys{
                    let strElement = String(element)
                    let strValueElement = parameters[strElement] as! String
                    //print(element)
                    multipartFormData.append(strValueElement.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: strElement)
                }
                
                multipartFormData.append(imageData, withName: "profile_image", fileName: "profile_image.png", mimeType: "image/png")
        },
            to: urlString,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        //print(response.result.value!)
                        //print(response.data as! NSData)
                        self.delegateObject.APIHelperSuccess(response.result.value! as AnyObject, name: name)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    // self.delegateObject.APIHelperFailed((responds.result.error?.localizedDescription)!, name: name)
                }
        }
        )
    }
 
}

//
//  WebService.swift
//  PlaygroundMVVM
//
//  Created by House on 2020/3/12.
//  Copyright © 2020 haohsu. All rights reserved.
//

import Foundation
import Alamofire

class WebService {
    
    static func get<T: Codable>(url: String,requestComplete: @escaping (_ success: Bool, _ message: String?, _ data: T?) -> Void) {
        
        AF.request(url).responseData { response in
            
            var success: Bool = false
            var message: String? = nil
            var data: T? = nil
            
            switch response.result {
                
            case .success(let result):
                
                success = true
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                data = try? decoder.decode(T.self, from: result)
                
            case .failure(let error):
                
                message = error.errorDescription
            }
            
            requestComplete(success, message, data)
        }
    }
    
}

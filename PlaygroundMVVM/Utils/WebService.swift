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
    
    static func get<T>(url: String,requestComplete: @escaping (_ success: Bool, _ message: String?, _ data: T?) -> Void) {
        
        AF.request(url).responseJSON { response in
            
            var success: Bool = false
            var message: String? = nil
            var data: T? = nil
            
            switch response.result {
                
            case .success(let json):
                
                success = true
                data = json as? T
                
            case .failure(let error):
                
                message = error.errorDescription
            }
            
            requestComplete(success, message, data)
        }
    }
    
}

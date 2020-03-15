//
//  BaseViewModel.swift
//  PlaygroundMVVM
//
//  Created by House on 2020/3/12.
//  Copyright © 2020 haohsu. All rights reserved.
//

import Foundation

class BaseViewModel {
    
    var title: String?
    
    var errorMessage: String? {
        didSet {
            self.showErrorAlert?()
        }
    }
    
    required init() {}
    
    // Closure
    
    var showErrorAlert: (()->())?
    
}

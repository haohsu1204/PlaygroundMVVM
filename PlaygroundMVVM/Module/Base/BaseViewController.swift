//
//  BaseViewController.swift
//  PlaygroundMVVM
//
//  Created by House on 2020/3/12.
//  Copyright © 2020 haohsu. All rights reserved.
//

import UIKit

class BaseViewController<T: BaseViewModel>: UIViewController {

    
    lazy var viewModel: T = {
        return T()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // init view model
        initViewModel()
        
        // Init the static view
        initView()
    }
    
    func initViewModel() {
       
        self.viewModel.showErrorAlert = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.errorMessage {
                    self?.showAlert( message )
                }
            }
        }
    }
    
    func initView() {
        
        self.navigationItem.title = viewModel.title
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Hint", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

}

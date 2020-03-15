//
//  PhotoListViewModel.swift
//  PlaygroundMVVM
//
//  Created by House on 2020/3/12.
//  Copyright © 2020 haohsu. All rights reserved.
//

import Foundation
import UIKit

class PhotoListViewModel: BaseViewModel  {
    
    private let apiUrl: String = "https://jsonplaceholder.typicode.com/photos"
    
    private let numberOfColumns: Int = 4
    
    var numberOfPhotos: Int {
        return self.photos.count
    }
    
    var cellSize: CGSize {
        let window = UIApplication.shared.windows[0]
        var width: CGFloat = window.bounds.width - ( window.safeAreaInsets.left + window.safeAreaInsets.right )
        width = width / CGFloat(self.numberOfColumns)
        return CGSize(width: width, height: width)
    }
    
    var cellSectionInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    var minimumInteritemSpacing: CGFloat {
        return 0
    }
    
    var minimumLineSpacing: CGFloat {
        return 0
    }
    
    
    var photos: [PhotoListCellViewModel] = [PhotoListCellViewModel]() {
        didSet {
            self.reloadListViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    // Closure
    
    var reloadListViewClosure: (()->())?
    
    var updateLoadingStatus: (()->())?
    
    
    required init() {
        super.init()
    }
    
    func fetchPhotoData() {
        
        self.isLoading = true
        WebService.get(url: apiUrl) { (success: Bool, message: String?, data: [[String : AnyObject]]?) in
            
            self.isLoading = false
            // handle exception
            if !success {
                self.errorMessage = message
                return
            }
            self.processPhotoData(data: data)
        }
    }
    
    func processPhotoData(data: [[String : AnyObject]]?) {
        
        var photos = [PhotoListCellViewModel]()
        if let _data = data {
            for dictionary in _data {
                let photo = Photo(dictionary: dictionary)
                photos.append(PhotoListCellViewModel(photo: photo))
            }
        }
        self.photos = photos
    }
    
    
}

class PhotoListCellViewModel: BaseViewModel {
    
    var photo: Photo
    
    var textId: String {
        get {
            return String(self.photo.id)
        }
    }
    
    var textTitle: String? {
        get {
            return self.photo.title
        }
    }
    
    var imageThumbnail: UIImage? {
        get {
            
            return nil
        }
    }
    
    var fatchImageTask: URLSessionTask?
    
    required init() {
        self.photo = Photo()
        super.init()
    }
    
    convenience init(photo: Photo) {
        self.init()
        self.photo = photo
    }
    
    func fetchImage(imageView: UIImageView) {
        
        imageView.accessibilityIdentifier = self.photo.thumbnailUrl
        imageView.image = nil
        
        if let urlString = self.photo.thumbnailUrl {
            
            if let cacheImage = ImageCache.shared.get(key: urlString) {
                imageView.image = cacheImage
                return
            }
            
            guard let url = URL(string: urlString) else { return }
            
            let sessionTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let _ = error {
                    return
                }
                
                guard let data = data else { return }
                if let image = UIImage(data: data) {
               
                    ImageCache.shared.put(key: urlString, image: image)
                    if imageView.accessibilityIdentifier != urlString {
                        return
                    }
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
            sessionTask.resume()
            self.fatchImageTask = sessionTask
        }
    }
    
    func stopFetchImage() {
        if let sessionTask = self.fatchImageTask {
            sessionTask.cancel()
        }
    }
}

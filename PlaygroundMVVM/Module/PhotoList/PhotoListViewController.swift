//
//  PhotoListViewController.swift
//  PlaygroundMVVM
//
//  Created by House on 2020/3/12.
//  Copyright © 2020 haohsu. All rights reserved.
//

import UIKit

class PhotoListViewController: BaseViewController<PhotoListViewModel> {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initViewModel() {
        super.initViewModel()
        
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        self.viewModel.updateLoadingStatus = { [weak self] () in
                   DispatchQueue.main.async {
                       let isLoading = self?.viewModel.isLoading ?? false
                        if isLoading {
                            self?.activityIndicator.startAnimating()
                            UIView.animate(withDuration: 0.3, animations: {
                                self?.collectionView.alpha = 0.0
                            })
                        }
                        else {
                            self?.activityIndicator.stopAnimating()
                            UIView.animate(withDuration: 0.3, animations: {
                                self?.collectionView.alpha = 1.0
                            })
                        }
                   }
               }
        
        self.viewModel.fetchPhotoData()
    }

    override func initView() {
        super.initView()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
}

extension PhotoListViewController: UICollectionViewDelegate {
    
    
}

extension PhotoListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfPhotos
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListViewCellIdentifier", for: indexPath) as? PhotoListViewCell
            else { fatalError("Cell not exists in storyboard") }
        
        let cellViewModel = self.viewModel.photos[indexPath.row]
        cell.viewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellViewModel = self.viewModel.photos[indexPath.row]
        cellViewModel.stopFetchImage()
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.viewModel.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.viewModel.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.viewModel.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.viewModel.cellSectionInset
    }
}

class PhotoListViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewThumbnail: UIImageView!
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    var viewModel: PhotoListCellViewModel? {
        didSet {
            self.labelId.text = viewModel?.textId
            self.labelTitle.text = viewModel?.textTitle
            viewModel?.fetchImage(imageView: self.imageViewThumbnail)
        }
    }
}

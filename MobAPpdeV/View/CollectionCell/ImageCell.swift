//
//  ImageCell.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/5/21.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!

    func install(_ image: UIImage?) {
        if image == nil {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        imageView.image = image
    }
}

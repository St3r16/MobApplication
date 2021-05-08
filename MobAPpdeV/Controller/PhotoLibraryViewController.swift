//
//  PhotoLibraryViewController.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/5/21.
//

import UIKit

class PhotoLibraryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        return picker
    } ()

    var images: [UIImage] = []
    {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        
        present(imagePicker, animated: true)
    }
    
}

extension PhotoLibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }

}

extension PhotoLibraryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
}

extension PhotoLibraryViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            dismiss(animated: true)
        }
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }

        self.images.append(image)

//        for _ in 0...10 {
//            self.images.append(image.copy() as! UIImage)
//        }

    }
    
}

extension PhotoLibraryViewController: UINavigationControllerDelegate {
}

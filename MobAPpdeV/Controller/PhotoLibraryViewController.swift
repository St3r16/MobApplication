//
//  PhotoLibraryViewController.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/5/21.
//

import UIKit

class PhotoLibraryViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!

    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        return picker
    } ()
    
    private var imageLoader: [IndexPath: UIImage?] = [:]
    
    private var links: [String] = []

    private var images: [UIImage?] = []
    
    @IBAction
    private func addPhoto(_ sender: Any) {
        present(imagePicker, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
    }

    private func loadImages() {
        struct ImageWrapper: Decodable {
            
            struct ImageInformation: Decodable {
                let largeImageURL: String
            }
            
            let hits: [ImageInformation]

        }
        
        var components = URLComponents(string: "https://pixabay.com/api/")
        let queryItems = [URLQueryItem(name: "key", value: "19193969-87191e5db266905fe8936d565"),
                          URLQueryItem(name: "q", value: "red+cars"),
                          URLQueryItem(name: "image_type", value: "photo"),
                          URLQueryItem(name: "per_page", value: "21")]
        components?.queryItems = queryItems

        guard let url = components?.url else { return }
        activityIndicator.startAnimating()
        perform(URLRequest(url: url)) { (result: Result<ImageWrapper, Error>) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                do {
                    let imagesInfo = try result.get()
                    self.links = imagesInfo.hits.map { $0.largeImageURL }
                    self.images.append(contentsOf: self.links.map {_ in nil} )
                    self.collectionView.reloadData()
                } catch {
                    self.showAlert(error: error)
                }
            }
        }

    }

    private func perform<T: Decodable>(_ urlRequest: URLRequest, with completion: @escaping (Result<T, Error>)->()) {
        URLSession.shared.dataTask(with: urlRequest) { (data, responce, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                    return
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }.resume()
    }
    
}

extension PhotoLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        statement:
        // if image is not loaded AND loading was not started
        if images[indexPath.row] == nil && !imageLoader.keys.contains(indexPath) {
            imageLoader[indexPath] = nil
            guard !links.isEmpty else {
                self.images[indexPath.row] = UIImage(systemName: "minus")
                self.imageLoader.removeValue(forKey: indexPath)
                break statement
            }
            let stringLink = links.removeFirst()
            Thread {
                print(indexPath)
                guard let link = URL(string: stringLink),
                      let data = try? Data(contentsOf: link) else {
                    DispatchQueue.main.async {
                        self.images[indexPath.row] = self.imageLoader[indexPath] ?? UIImage(systemName: "plus")
                        self.imageLoader.removeValue(forKey: indexPath)
                        collectionView.reloadItems(at: [indexPath])
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.imageLoader[indexPath] = UIImage(data: data)
                    self.images[indexPath.row] = self.imageLoader[indexPath] ?? UIImage(systemName: "plus")
                    self.imageLoader.removeValue(forKey: indexPath)
                    collectionView.reloadItems(at: [indexPath])
                }
            }.start()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.install(images[indexPath.row])
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
        collectionView.insertItems(at: [IndexPath(item: images.count-1, section: 0)])
    }
    
}

extension PhotoLibraryViewController: UINavigationControllerDelegate {
}

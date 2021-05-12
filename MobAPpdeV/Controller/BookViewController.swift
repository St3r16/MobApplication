//
//  BookViewController.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/3/21.
//

import UIKit

enum LoadingError: Error {
    case invalidData
    case differentModel
}

class BookViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    private var books: [Book] = []
    private var selectedBookIndex: Int?
    private var imageLoader: [IndexPath: UIImage?] = [:]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailedBookController,
           let index = selectedBookIndex {
            vc.book = books[index]
        }
    }
    
}

extension BookViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchBooks(containing: searchText) { result in
            DispatchQueue.main.async {
                do {
                    let res = try result.get()
                    self.books = res
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                } catch {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(error: error)
                }
            }
        }
        
    }
    
    private func fetchBooks(containing query: String, in completion: @escaping (Result<[Book], Error>) -> Void) {
        guard query.count > 2,
              let url = URL(string: "https://api.itbook.store/1.0/search/\(query)") else {
            completion(.success([]))
            return
        }
        imageLoader.removeAll()
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(LoadingError.invalidData))
                return
            }
            
            struct BookWrapper: Decodable {
                let books: [Book]
            }
            
            guard let wrapper = try? JSONDecoder().decode(BookWrapper.self, from: data) else {
                completion(.failure(LoadingError.differentModel))
                return
            }
            completion(.success(wrapper.books))
        }.resume()
    }
    
}

extension BookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        statement:
        // if image is not loaded AND loading was not started
        if book.preview == nil && !imageLoader.keys.contains(indexPath) {
            imageLoader[indexPath] = nil
            Thread {
                guard let link = URL(string: self.books[indexPath.row].imageName),
                      let data = try? Data(contentsOf: link) else {
                    DispatchQueue.main.async {
                        if self.books.count >= indexPath.row {
                            book.preview = self.imageLoader[indexPath] ?? UIImage(systemName: "plus")
                            self.imageLoader.removeValue(forKey: indexPath)
                            if let cell = tableView.cellForRow(at: indexPath),
                               tableView.visibleCells.contains(cell) {
                                tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                    }
                    return
                }
                DispatchQueue.main.async {
                    if self.books.count >= indexPath.row {
                        self.imageLoader[indexPath] = UIImage(data: data)
                        book.preview = self.imageLoader[indexPath] ?? UIImage(systemName: "plus")
                        self.imageLoader.removeValue(forKey: indexPath)
                        if let cell = tableView.cellForRow(at: indexPath),
                           tableView.visibleCells.contains(cell) {
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }.start()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell else {
            return UITableViewCell()
        }
        
        cell.setUp(with: books[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            books.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension BookViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedBookIndex = indexPath.row
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

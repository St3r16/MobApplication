//
//  BookViewController.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/3/21.
//

import UIKit

class BookViewController: UIViewController {
    
    private var books: [Book] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUpBooks()
    }

    func fetchUpBooks() {
        do {
        let books = try decodeBooks()

            self.books = books

        } catch {

            let ac = UIAlertController(title: "Opps!", message: error.localizedDescription, preferredStyle: .alert)
            let aa = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            ac.addAction(aa)
            self.present(ac, animated: true, completion: nil)

        }
    }
    
    func decodeBooks() throws -> [Book] {
        
        let decoder = JSONDecoder()
        
        struct BookWrapper: Decodable {
            
            let books: [Book]
            
        }
        
        enum DecodeError: LocalizedError {
            case invalidUrl
            case invalidData
            case invalidDecodeModel
            
            var errorDescription: String? {
                switch self {
                case .invalidData:
                    return "Unable to retrieve data from file!"
                case .invalidDecodeModel:
                    return "Incompatible model!"
                case .invalidUrl:
                    return "Unable to find file in bundle!"
                }
            }
        }
        
        guard let url = Bundle.main.url(forResource: "BooksList", withExtension: "txt") else {
            throw DecodeError.invalidUrl
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw DecodeError.invalidData
        }
        
        guard let wrapper = try? decoder.decode(BookWrapper.self, from: data) else {
            throw DecodeError.invalidDecodeModel
        }
        
        return wrapper.books
    }
}

extension BookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell else {
            return UITableViewCell()
        }
        
        cell.setUp(with: books[indexPath.row])
        
        return cell
    }
    
    
}

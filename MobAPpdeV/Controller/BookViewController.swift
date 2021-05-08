//
//  BookViewController.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/3/21.
//

import UIKit

class BookViewController: UIViewController {

    var filterMethod: ((Book) -> Bool) = { _ in
        return true
    } {
        didSet {
            showingBooks = books.filter(filterMethod)
        }
    }
    
    var books: [Book] = [] {
        didSet {
            showingBooks = books.filter(filterMethod)
        }
    }
    var showingBooks: [Book] = []
    @IBOutlet weak var tableView: UITableView!

    var selectedBookIndex: Int?
    var selectedBook: DetailedBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUpBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    func fetchUpBooks() {
        do {

            struct BookWrapper: Decodable {
                let books: [Book]
            }

            let wrapper = try Bundle.main.decodeJSON("BooksList.txt", of: BookWrapper.self)

            self.books = wrapper.books
            self.tableView.reloadData()
        } catch {

            showAlert(error: error)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailedBookController,
           let book = selectedBook {
            vc.book = book
        } else if let vc = segue.destination as? NewBookController {
            vc.delegate = self
        } else {
            return
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "DetailedBook" {

            if let index = self.selectedBookIndex,
               let book = try? Bundle.main.decodeJSON(showingBooks[index].isbn13 + ".txt", of: DetailedBook.self) {
                self.selectedBook = book
                return true
            } else {
                return false
            }
        } else {
            return true
        }

    }

}

extension BookViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        defer {
            self.tableView.reloadData()
        }
        
        guard !searchText.isEmpty else {
            self.filterMethod = { _ in return true }
            
            return
        }
        
        let lowercasedSearch = searchText.lowercased()

        self.filterMethod = { $0.title.lowercased().contains(lowercasedSearch) }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        defer {
            searchBar.resignFirstResponder()
        }

        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }

        self.searchBar(searchBar, textDidChange: searchText)

    }
}

extension BookViewController: NewBookViewControllerDelegate {

    func createdNewBook(_ book: Book) {
        self.books.append(book)
    }

}

extension BookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showingBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell else {
            return UITableViewCell()
        }
        
        cell.setUp(with: showingBooks[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let showingIndex = indexPath.row
            let showingBook = showingBooks[showingIndex]
            guard let allIndex = books.firstIndex(of: showingBook) else {
                return
            }
            
            books.remove(at: allIndex)
            
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

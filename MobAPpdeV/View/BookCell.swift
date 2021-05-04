//
//  BookCell.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/3/21.
//

import UIKit

class BookCell: UITableViewCell {
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookDescription: UILabel!
    @IBOutlet weak var BookImageView: UIImageView!
    @IBOutlet weak var price: UILabel!
    
    
    func setUp(with book: Book) {
        self.bookNameLabel.text = book.title
        self.BookImageView.image = book.preview
        self.bookDescription.text = book.subtitle
        self.price.text = book.price
    }
}

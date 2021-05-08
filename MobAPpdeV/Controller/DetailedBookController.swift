//
//  DetailedBookController.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/4/21.
//

import UIKit

class DetailedBookController: UIViewController {
    
    var book: DetailedBook?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.contentMode = .scaleToFill
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    private let bookImageView: UIImageView = {
        let bookImageView = UIImageView()
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        return bookImageView
    }()
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    } ()
    
    private let bookSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    } ()
    
    private let descriptionBookLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    } ()
    
    private let authorBookLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    } ()

    private let publisherBookLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    } ()

    private let pagesBookLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    } ()
    
    private let yearBookLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    } ()

    private let ratingBookLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makePreparations()
    }

    private func makePreparations() {
        installTitle()
        if let book = book {
            setupScrollView()
            setupViews(with: book)
        } else {
            showNoBook()
        }
    }

}

// MARK: - View instalation
extension DetailedBookController {
    
    private func setupViews(with book: DetailedBook) {

        contentView.addSubview(bookImageView)
        bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bookImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        bookImageView.heightAnchor.constraint(equalTo: bookImageView.widthAnchor).isActive = true
        bookImageView.image = book.preview


        contentView.addSubview(bookTitleLabel)
        bookTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bookTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bookTitleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor).isActive = true
        bookTitleLabel.attributedText = createAtributed(with: "Title", and: book.title)


        contentView.addSubview(bookSubtitleLabel)
        bookSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bookSubtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bookSubtitleLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor).isActive = true
        bookSubtitleLabel.attributedText = createAtributed(with: "Subtitle", and: book.subtitle)


        contentView.addSubview(descriptionBookLabel)
        descriptionBookLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        descriptionBookLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        descriptionBookLabel.topAnchor.constraint(equalTo: bookSubtitleLabel.bottomAnchor).isActive = true
        descriptionBookLabel.attributedText = createAtributed(with: "Description", and: book.desc)


        contentView.addSubview(authorBookLabel)
        authorBookLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        authorBookLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        authorBookLabel.topAnchor.constraint(equalTo: descriptionBookLabel.bottomAnchor, constant: 25).isActive = true
        authorBookLabel.attributedText = createAtributed(with: "Authors", and: book.authors)


        contentView.addSubview(publisherBookLabel)
        publisherBookLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        publisherBookLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        publisherBookLabel.topAnchor.constraint(equalTo: authorBookLabel.bottomAnchor).isActive = true
        publisherBookLabel.attributedText = createAtributed(with: "Publisher", and: book.publisher)


        contentView.addSubview(pagesBookLabel)
        pagesBookLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pagesBookLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pagesBookLabel.topAnchor.constraint(equalTo: publisherBookLabel.bottomAnchor, constant: 25).isActive = true
        pagesBookLabel.attributedText = createAtributed(with: "Pages", and: book.pages)


        contentView.addSubview(yearBookLabel)
        yearBookLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        yearBookLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        yearBookLabel.topAnchor.constraint(equalTo: pagesBookLabel.bottomAnchor).isActive = true
        yearBookLabel.attributedText = createAtributed(with: "Year", and: book.year)



        contentView.addSubview(ratingBookLabel)
        ratingBookLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        ratingBookLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        ratingBookLabel.topAnchor.constraint(equalTo: yearBookLabel.bottomAnchor).isActive = true
        ratingBookLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        ratingBookLabel.attributedText = createAtributed(with: "Rating", and: book.rating + "/5.0")
    }
    
    func createAtributed(with title: String, and subtitle: String) -> NSAttributedString {
        let string = NSMutableAttributedString(string: "\(title): ",
                                            attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        string.append(NSAttributedString(string: subtitle))
        
        return string
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 6/7).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func showNoBook() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No book description."
        
        self.view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func installTitle() {
        self.title = "Details"

    }
    
}

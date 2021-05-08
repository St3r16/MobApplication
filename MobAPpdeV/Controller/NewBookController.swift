//
//  NewBookController.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/4/21.
//

import UIKit

protocol NewBookViewControllerDelegate: class {

    func createdNewBook(_ book: Book)

}

class NewBookController: UIViewController {

    weak var delegate: NewBookViewControllerDelegate?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    private let views: [(UILabel, UITextField)] = {
        let texts = ["Title", "Subtitle", "Price"]
        let array: [(UILabel, UITextField)] = (0..<texts.count).map { _ in return (UILabel(), UITextField()) }
        
        for (index, text) in texts.enumerated() {

            array[index].1.translatesAutoresizingMaskIntoConstraints = false
            array[index].1.placeholder = text
            array[index].1.borderStyle = .roundedRect
            
            array[index].0.translatesAutoresizingMaskIntoConstraints = false
            array[index].0.text = text
        }
        
        return array
    } ()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.contentMode = .scaleToFill
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .blue
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makePreparations()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    private func makePreparations() {
        setupScrollView()
        setupViews()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset

    }

    enum BookInputError: LocalizedError {
        case shortTitle
        case shortSubtitle
        case invalidPrice
        
        var errorDescription: String? {
            switch self {
            case .shortTitle:
                return "Title must be more than 3 characters!"
            case .shortSubtitle:
                return "Subtitle must be more than 5 characters!"
            case .invalidPrice:
                return "Price must be in format \"0.00\"!"
            }
        }
    }
    
    @objc func buttonTapped() {
        let input = views.compactMap({ $0.1.text })

        guard input.count == 3 else {
            return
        }
        
        let title = input[0]
        let subtitle = input[1]
        let price = input[2]
        
        if title.count > 3 {
            
            if subtitle.count > 5 {
                
                if let doublePrice = Double(price) {
                    
                    let stringPrice = String(format: "$%.2f", doublePrice)
                    let book = Book(title: title, subtitle: subtitle, isbn13: "", price: stringPrice, imageName: "")
                    
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.createdNewBook(book)
                } else {
                    showAlert(error: BookInputError.invalidPrice)
                }
            } else {
                showAlert(error: BookInputError.shortSubtitle)
            }
        } else {
            showAlert(error: BookInputError.shortTitle)
        }
        

    }

}

// MARK: - View instalation
extension NewBookController {
    
    private func setupViews() {
        
        for index in 0..<views.count {
            let (label, field) = views[index]
            
            contentView.addSubview(label)
            
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            
            if index == 0 {
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: views[index-1].1.bottomAnchor, constant: 25).isActive = true
            }
            
            contentView.addSubview(field)
            
            field.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            field.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            field.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
            
        }

        contentView.addSubview(addButton)
        addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: views[views.count - 1].1.bottomAnchor, constant: 20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

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
    
    private func installTitle() {
        self.title = "Details"
    }
    
}

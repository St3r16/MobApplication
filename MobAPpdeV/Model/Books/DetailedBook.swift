//
//  DetailedBook.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/4/21.
//

import UIKit

struct DetailedBook: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case subtitle
        case isbn13
        case price
        case imageName = "image"
        case authors
        case publisher
        case pages
        case year
        case rating
        case desc
        
       
    }
    
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let pages: String
    let year: String
    let rating: String
    let desc: String
    
    let isbn13: String
    let price: String
    let imageName: String

    var preview: UIImage? {
        guard !imageName.isEmpty else {
            return UIImage(systemName: "multiply.circle")
        }
        return UIImage(named: imageName)
    }
    
    
}

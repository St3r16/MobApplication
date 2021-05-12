//
//  Book.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/3/21.
//

import UIKit

class Book: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case subtitle
        case isbn13
        case price
        case imageName = "image"
        
    }
    
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let imageName: String

    var preview: UIImage?

}

//extension Book: Equatable {
//    
//    
//}

//
//  Bundle.swift
//  MobAPpdeV
//
//  Created by sterbro on 5/4/21.
//

import Foundation

extension Bundle {

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
    
    
    func decodeJSON<T: Decodable>(_ file: String, of type: T.Type) throws -> T {
        
        let decoder = JSONDecoder()
        
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            throw DecodeError.invalidUrl
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw DecodeError.invalidData
        }
        
        guard let item = try? decoder.decode(type.self, from: data) else {
            throw DecodeError.invalidDecodeModel
        }
        
        return item
    }

}

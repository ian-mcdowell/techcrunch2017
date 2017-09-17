//
//  ImageOCRResult.swift
//  Hackathon
//
//  Created by Ian McDowell on 9/16/17.
//  Copyright © 2017 Hackathon. All rights reserved.
//

import Foundation

enum ImageOCRResultError: Error {
    case invalidJSON
}


struct ImageOCRResult {
    
    let words: [String]
    
    init(azureJSON json: [String: Any]) throws {
        guard let regions = json["regions"] as? [[String: Any]] else {
            throw ImageOCRResultError.invalidJSON
        }
        
        var all = [String]()
        for region in regions {
            guard let lines = region["lines"] as? [[String: Any]] else {
                throw ImageOCRResultError.invalidJSON
            }
            
            for line in lines {
                guard let words = line["words"] as? [[String: Any]] else {
                    throw ImageOCRResultError.invalidJSON
                }
                
                for word in words {
                    guard let text = word["text"] as? String else {
                        throw ImageOCRResultError.invalidJSON
                    }
                    
                    all.append(text)
                }
            }
        }
        
        self.words = all
    }
    
    init(tesseractString: String) {
        words = tesseractString.components(separatedBy: .whitespacesAndNewlines).filter({ !$0.isEmpty }).map({ $0.replacingOccurrences(of: ".", with: "")})
    }
}

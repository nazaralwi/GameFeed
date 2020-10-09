//
//  Formatter.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 07/10/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

class Formatter {
    class func formatGenre(from genresFromAPI: [Genre]) -> String {
        var genres = [String]()
        for genre in genresFromAPI {
            let genreName = genre.name
            genres.append(genreName)
        }
        
        return genres.joined(separator: ", ")
    }
    
    class func formatDate(from dateFromAPI: String) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatterGet.date(from: dateFromAPI) {
            return dateFormatterPrint.string(from: date)
        } else {
            return "There was an error decoding the string"
        }
    }
}

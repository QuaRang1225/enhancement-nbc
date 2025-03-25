//
//  Date.swift
//  project-book-series
//
//  Created by 유영웅 on 3/25/25.
//

import Foundation

//MARK: ex) 1998-07-02 -> June 26, 1997
extension String{
    func getAmericaDateFormatter() -> String{
        //입력 변환
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: self) else { return "" }
        
        //출력 변환
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM dd, yyyy"
        
        return outputFormatter.string(from: date)
    }
}

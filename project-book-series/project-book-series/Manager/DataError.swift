//
//  DataError.swift
//  project-book-series
//
//  Created by 유영웅 on 3/24/25.
//

import Foundation

//MARK: DataError
//Json 디코딩 시 실패 케이스
enum DataError: String,Error {
    case fileNotFound  = "File no found"  //파일을 찾을 수 없음
    case parsingFailed = "Parsing faild"  //변환 실패
}

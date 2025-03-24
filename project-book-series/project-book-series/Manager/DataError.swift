//
//  DataError.swift
//  project-book-series
//
//  Created by 유영웅 on 3/24/25.
//

import Foundation

//MARK: DataError
//Json 디코딩 시 실패 케이스
enum DataError: Error {
    case fileNotFound   //파일을 찾을 수 없음
    case parsingFailed  //변환 실패
}

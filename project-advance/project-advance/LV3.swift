//
//  LV3.swift
//  project-advance
//
//  Created by 유영웅 on 3/19/25.
//

import Foundation

//요소의 타입별로 사용하기 위해 제네릭으로 선언
//요구사항 중  << 'Numeric 프로토콜'을 준수하는 타입의 요소를 가진 배열 >>이 있어 추가
func a(_ arr:[Int])->[Int]{
    (0..<arr.count).filter{ $0%2 == 0 }.map{ arr[$0] }
}
//String은 Numeric 프로토콜을 쓰지 않음으로 Stirng으로 변환
func b(_ arr:[String])->[String]{
    (0..<arr.count).filter{ $0%2 == 0 }.map{ arr[$0] }
}
//a에 Numeric 의존을 삭제
func c<T>(_ arr:[T])->[T]{
    (0..<arr.count).filter{ $0%2 == 0 }.map{ arr[$0] }
}
//a 내용 그대로 사용하고 a는 Int만을 사용하도록 수정
func d<T:Numeric>(_ arr:[T])->[T]{
    (0..<arr.count).filter{ $0%2 == 0 }.map{ arr[$0] }
}

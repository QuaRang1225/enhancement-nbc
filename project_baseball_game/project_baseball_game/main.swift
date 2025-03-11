//
//  main.swift
//  project_baseball_game
//
//  Created by 유영웅 on 3/10/25.
//

import Foundation


//정답값의 Char형의 배열을 반환하는 함수 ex) 123 -> ["1","2","3"]
//1. 정답과 입력값을 비교할 때 각 자리별로 검사하기 때문에 [Character]로 반환하고, 요구사항에 만족하는 데이터가 나올때 까지 루프 실행
//2. 정답은 겹치는 숫자가 포함되있을 수 없으며, 항상 2자리를 유지하고, 0이 포함되어있지 않아야 함
private func getCorrectNumber() -> [Character] {
    while true {
        let num = Int.random(in: 123...999)
        let digits = Array(String(num))
        guard Set(digits).count == 3,!digits.contains("0") else{ continue }
        return digits
    }
}
//입력에 따라 각 결과를 출력하는 함수
//1. 정답과 입력값을 각 자리수대로 검사해, 스트라이크와 볼의 개수를 카운트
//2. 스트라이크가 존재할 때 \() 스트라이크를 출력
//3. 볼이 존재할 때 결과 메세지의 배열이 비어있지 않다면(이미 스트라이크가 존재한다면), 콤마(,)를 추가하고 \() 볼 메세지 추가
//4. 만약 스트라이크 볼 모두 존재하지 않을 경우(result)가 비었을 경우 Nothing 출력
private func getResult(digits:[Character],correctDigits:[Character])->String{
    
    var strikeCount = 0
    var ballCount = 0
    
    zip(digits, correctDigits).forEach{
        if $0.0 == $0.1{
            strikeCount += 1
        }else if correctDigits.contains($0.0){
            ballCount += 1
        }
    }
    
    var resultMessage = ""
    
    if strikeCount > 0 {
        resultMessage += "\(strikeCount) 스트라이크"
    }
    if ballCount > 0 {
        if !resultMessage.isEmpty { resultMessage += ", " }
        resultMessage += "\(ballCount) 볼"
    }
    if resultMessage.isEmpty {
        resultMessage = "Nothing"
    }
    return resultMessage
}
//메인 게임 실행 메서드
//1. 루프를 돌며 숫자를 입력받음
//2. 임력값이 3글자 이상 숫자일때로 제한하고, 숫자를 비교해 정답일 경우 return(이미 정답은 0을 포함하지 않기 때문에 붑필요한 계산을 피하기 위함)
//3. 정답이 아니라면, 0이 포함 안되게 제한
private func playGame() {
    
    let correct = getCorrectNumber()
    print("< 게임을 시작합니다 >")
    
    while true {
        print("숫자를 입력하세요")
        let input = readLine()!
        guard input.count == 3,
              let number = Int(input) else {
            print("올바르지 않은 입력값입니다."); print()
            continue
        }
        let digits = Array(String(number))
        
        if digits == correct {
            print("정답입니다!")
            return
        }
        guard !digits.contains("0") else {
            print("올바르지 않은 입력값입니다."); print()
            continue
        }
        
        print(getResult(digits: digits, correctDigits: correct))
        print()
    }
}

playGame()




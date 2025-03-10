//
//  main.swift
//  project_baseball_game
//
//  Created by 유영웅 on 3/10/25.
//

import Foundation



func getCorrectNumber() -> (num:Int,digits:[Character]) {
    while true {
        let num = Int.random(in: 123...999)
        let digits = Array(String(num))
        guard Set(digits).count == 3,!digits.contains("0") else{ continue }
        return (num,digits)
    }
}

private func playGame() {
    let correct = getCorrectNumber()
    print("< 게임을 시작합니다 >")
    print(correct.num)
    while true {
        print("숫자를 입력하세요")
        let input = readLine()!
        guard input.count == 3,
              let number = Int(input) else {
            print("올바르지 않은 입력값입니다."); print()
            continue
        }
        
        let digits = Array(String(number))
        if number == correct.num {
            print("정답입니다!")
            return
        }
        
        var strikeCount = 0
        var ballCount = 0
        
        for (index, digit) in digits.enumerated() {
            if correct.digits[index] == digit {
                strikeCount += 1
            } else if correct.digits.contains(digit) {
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
        
        print(resultMessage)
        print()
    }
}

playGame()



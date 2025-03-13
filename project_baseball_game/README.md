# Swift로 야구게임 만들기

🚀 요구사항

```
숫자 야구 게임은 두 명이 즐길 수 있는 추리 게임으로, 상대방이 설정한 3자리의 숫자를 맞히는 것이 목표입니다.
각 자리의 숫자와 위치가 모두 맞으면 '스트라이크', 숫자만 맞고 위치가 다르면 '볼'로 판정됩니다. 예를 들어,
상대방의 숫자가 123일 때 132를 추리하면 1스트라이크 2볼이 됩니다. 이러한 힌트를 활용하여 상대방의
숫자를 추리해 나가는 게임입니다.
```

## 🏆 완성도
| Lv1 | Lv2 | Lv3 | Lv4 | Lv5 | Lv6 |
|---|---|---|---|---|---|
| ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

## 📌 주요 기능
- ✅ 랜덤 정답 생성
  - 정답값의 Char형의 배열을 반환하는 함수 ex) 123 -> ["1","2","3"]
  - 정답과 입력값을 비교할 때 각 자리별로 검사하기 때문에 [Character]로 반환하고, 요구사항에 만족하는 데이터가 나올때 까지 루프 실행
  - 정답은 겹치는 숫자가 포함되있을 수 없으며, 항상 2자리를 유지하고, 0이 포함되어있지 않아야 함
  ```swift
  private func getCorrectNumber() -> [Character] {
    while true {
        let num = Int.random(in: 123...999)
        let digits = Array(String(num))
        guard Set(digits).count == 3,!digits.contains("0") else{ continue }
        return digits
    }
  }
  ```
- ✅ 정답을 맞추기 위해 3자리수를 입력하고 힌트문자 출력하는 함수
   - 정답과 입력값을 각 자리수대로 검사해, 스트라이크와 볼의 개수를 카운트
   - 스트라이크가 존재할 때 \() 스트라이크를 출력
   - 볼이 존재할 때 결과 메세지의 배열이 비어있지 않다면(이미 스트라이크가 존재한다면), 콤마(,)를 추가하고 \() 볼 메세지 추가
   - 만약 스트라이크 볼 모두 존재하지 않을 경우(result)가 비었을 경우 Nothing 출력
  ```swift
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
  ```
- ✅ 잘못된 입력에 대한 예외처리
  - 메인 게임 실행 메서드
  - 루프를 돌며 숫자를 입력받음
  - 입력값을 숫자로만 제한
  - 임력값과 정답을 비교해 정답일 경우 return(이미 정답은 조건에 만족하기 때문에 불필요한 계산을 피하기 위함)
  - 정답이 아니라면, 겹치는 수 없이 3자리수이며 0이 포함 안되게 제한
  ```swift
  func playGame() {
    
    let correct = getCorrectNumber()
    print("< 게임을 시작합니다 >")
    
    while true {
        print("숫자를 입력하세요")
        let input = readLine()!
        guard let number = Int(input) else {
            print("올바르지 않은 입력값입니다."); print()
            continue
        }
        let digits = Array(String(number))
        
        if digits == correct {
            print("정답입니다!")
            return
        }
        guard Set(digits).count == 3,!digits.contains("0") else {
            print("올바르지 않은 입력값입니다."); print()
            continue
        }
        
        print(getResult(digits: digits, correctDigits: correct))
        print()
    }
  }
  ```
- ✅ 게임 옵션 선택
  - 클로져로 감싸 기존에 메인 게임실행 메서드를 크게 수정하는 일 없도록 수정
  - 게임수와 시도횟수를 저장할 딕셔너리 선언
  - 매 게임 시 횟수를 저장했다가 정답을 맞출 경우 횟수를 클로저 반환갑 넘겨받아 딕셔너리에 저장
  - 번호에 따라 모드 설정
  ```swift
  private func gameOption(completion:@escaping ()->Int){
    var score:[Int:Int] = [:]
    var numOfGame = 1
    while true{
        print("환영합니다! 원하시는 번호를 입력해주세요")
        print("1. 게임 시작하기  2. 게임 기록 보기  3. 종료하기")
        guard let input = Int(readLine()!) else { print("올바른 숫자를 입력해주세요!"); print(); continue }
        
        switch input{
        case 1: score[numOfGame] = completion(); numOfGame += 1
        case 2: score.isEmpty ? print("게임을 진행해주세요\n") : score.forEach{ print("\($0.key)번째 게임 : 시도 횟수 - \($0.value)") }; print()
        case 3: print("< 숫자 야구 게임을 종료합니다 >"); print(); return
        default: print("올바른 숫자를 입력해주세요!"); print();
        }
    }
  }
  ```

### 😀 느낀 점
```
오랜만에 앱 프로그래밍이 아닌, 이런 소형 게임을 만드니 처음 코딩을 시작할 때 생각도 나고 재밌었습니다.
코딩 테스트하는 것처럼 성능이나, 가독성을 고려해 볼 기회가 있어서 개인적인 학습에도 도움되었다고 생각합니다.
```

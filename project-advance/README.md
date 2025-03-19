# 📌 심화주차 과제

## 📝 개요
Swift에서 활용할 수 있는 **커스텀 클로저, 커스텀 고차함수, 커스텀 제네릭 함수**를 정의하고 사용법을 구현

---

- [x] 필수 1️⃣ 
- [x] 필수 2️⃣
- [x] 필수 3️⃣
- [ ] 도전 1️⃣ 
      
## 1️⃣ 커스텀 클로저 (Custom Closure)
### 정의  
- 두 개의 `Int` 값을 입력으로 받고, 그들의 합을 `String` 형태로 반환하는 클로저
- `calculate` 함수를 통해 클로저를 호출하여 결과를 출력

### 코드
```swift
let sum: (Int, Int) -> String = { (a, b) in
    return "두 수의 합은 \(a + b) 입니다"
}

func calculate(completion: (Int, Int) -> String) {
    let result = completion(10, 20)
    print(result)
}

// 사용 예시
calculate(completion: sum)
// 출력: "두 수의 합은 30 입니다"
```
## 2️⃣ 커스텀 고차함수 (Custom Higher-Order Function)

### 정의
- 주어진 배열의 각 요소를 변환하는 커스텀 map 함수
- Int 배열을 받아 String 배열로 변환
### 코드
```swift
func myMap(_ arr: [Int], completion: (Int) -> String) -> [String] {
    arr.map { completion($0) }
}

// 사용 예시
let result = myMap([1, 2, 3, 4, 5]) {
    String($0)
}

print(result) // 출력: ["1", "2", "3", "4", "5"]
```

## 3️⃣ 커스텀 제네릭 함수 (Custom Generic Function)

### 정의
- 제네릭(Generic)을 활용하여 짝수 인덱스 요소만을 반환하는 함수
- 다양한 타입을 처리하기 위해 제네릭(T)을 사용
- Numeric 프로토콜을 활용한 버전과 일반적인 버전 제공
### 코드
```swift
// Int 배열에서 짝수 인덱스의 요소만 반환
func a(_ arr: [Int]) -> [Int] {
    (0..<arr.count).filter { $0 % 2 == 0 }.map { arr[$0] }
}

// String 배열에서 짝수 인덱스의 요소만 반환
func b(_ arr: [String]) -> [String] {
    (0..<arr.count).filter { $0 % 2 == 0 }.map { arr[$0] }
}

// 모든 타입의 배열을 처리하는 제네릭 함수
func c<T>(_ arr: [T]) -> [T] {
    (0..<arr.count).filter { $0 % 2 == 0 }.map { arr[$0] }
}

// Numeric 프로토콜을 준수하는 타입(Int, Double 등)만을 처리하는 제네릭 함수
func d<T: Numeric>(_ arr: [T]) -> [T] {
    (0..<arr.count).filter { $0 % 2 == 0 }.map { arr[$0] }
}

// 사용 예시
let intResult = d([1, 2, 3, 4, 5, 6])
let stringResult = c(["A", "B", "C", "D", "E"])

print(intResult)    // 출력: [1, 3, 5]
print(stringResult) // 출력: ["A", "C", "E"]
```

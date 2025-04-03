# LEVEL 01 

## 📝 키포인트

### JsonManager 구현
```swift
//MARK: DataError
enum DataError: Error {
    case fileNotFound   //파일을 찾을 수 없음
    case parsingFailed  //변환 실패
}

//MARK: Json파일 디코딩 매니저
final class JsonManager{
    static func loadJson() async throws -> Result<[Attributes],DataError>{
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { throw DataError.fileNotFound}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let bookResponse = try JSONDecoder().decode(Episode.self, from: data)
            return .success(bookResponse.data.map{ $0.attributes })
        } catch {
            print("🚨 JSON 파싱 에러 : \(error)")
            throw DataError.parsingFailed
        }
    }
}
```
- Json 디코딩 시 실패 케이스 작성
- 앱 실행 시 한번만 초기화 하여 프로퍼티에 저장하여 사용하기 위한 JsonManager 구현
- 상태성을 가질 필요가 없기 때문에 타입 메서드로 구현
- 불필요한 클로져를 최소화 하고자 `swift concurrency` 사용

### 이벤트 핸들링
```swift
final class BookViewController: UIViewController {
    
    private let bookView = BookView()
    
    private func fetchInfo(){
        Task{
            let data = try await JsonManager.loadJson()
            switch data{
            case let .success(attributes):
                bookView.config(attributes: attributes)
                bookView.layoutIfNeeded()
            case let .failure(error): print(error.localizedDescription)
            }
        }
    }
}
```

- VC에서 이벤트 성패에 따라 분기처리

### 테스트 코드 작성
```swift
import Testing
@testable import project_book_series

struct project_book_seriesTests {

    //MARK: 파일을 찾을 수 없을 때
    @Test func fileNotFound() async throws {
        await #expect(throws:DataError.fileNotFound){
            try await JsonManager.loadJson()
        }
    }
    //MARK: 파싱이 불가능할 때()
    @Test func parsingFailed() async throws {
        await #expect(throws:DataError.parsingFailed){
            try await JsonManager.loadJson()
        }
    }
}
```
각각의 에러 상황이 발생할 때를 검출하기 위한 테스트 코드 작성

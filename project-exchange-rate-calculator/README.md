## 🛠 기술 스택
- UIKit: UI 구성
- RxSwift / RxCocoa: 반응형 프로그래밍 적용
- MVVM/Clean Architecture: 뷰와 비즈니스 로직 분리 및 뷰 바인딩
- Swift concurrency: Json 데이터 디코딩 Manger에 적용
- Swift Testing: json 인코딩 실패케이스를 감지하기 위함(시간 부족으로 완벽히는 사용하지 못함)
- CoreData: 환율 데이터 및 스크린 상태 저장


## 🖥 주요 기능


<details>
<summary>LEVEL 01</summary>
<div markdown="1">

### Level 1 - 메인 UI 기초 작업 + 데이터 불러오기
- API Manager를 구현하고, 초기 설정을 중심으로 구현했습니다.
- Model을 선언에 디코딩 용이한 환경을 확립했습니다.
- 네트워크 요청 실패를 대비해 DataError타입을 선언했습니다.
- RxSwift의 State-Action구조로 ViewModel을 설계 했습니다.
- 바인딩 시 이벤트에 따른 액션을 ViewModel로 방출하고 액션에 따른 이벤트를 처리해 Model을 업데이트하는 단방향 흐름을 구현했습니다.



</div>
</details>

<details>
<summary>LEVEL 02</summary>
<div markdown="1">

### Level 2 - 메인 화면 구성 
- 요구사항에 따라 컴포넌트 선언과 레이아웃 배치를 진행했습니다.

트러블 슈팅
- 실수로 검색바보다 테이블 뷰를 먼저 추가해 테이블 뷰를 스크롤 할 때 네비게이션바도 같이 스크롤 되는 문제가 생김
- View Debugger (Debug View Hierarchy)로 확인해본 결과 계층적인 문제가 없었음
- UIView에 테이블뷰를 addSubView로 추가하면 iOS 시스템에서 스크롤이 가능한 객체를 인식해 네비게이션 바도 스크롤 타입에 맞게 모드가 변하는 문제로 예상했음
- 결과적으로는 view에 addSubView를 할 때 검색바를 추가하고 테이블뷰를 추가하는 과정을 거쳐 해결함


</div>
</details>

</div>
</details>

<details>
<summary>LEVEL 03</summary>
<div markdown="1">

### Level 3 - 필터링 기능 구현
- 텍스트 입력을 감지해 액션을 방출하는 케이스를 추가했습니다.



</div>
</details>

<details>
<summary>LEVEL 04</summary>
<div markdown="1">

### Level 4 - 환율 계산기로 이동
- 요구사항에 맞게 환율 계산기 버튼을 구현했습니다.
- 각 cell의 데이터를 새로운 ViewController로 넘겨 초기화하는 방식을 사용했습니다.


</div>
</details>

<details>
<summary>LEVEL 05</summary>
<div markdown="1">

### Level 5 - 입력한 금액 실시간 반영
- 새로운 CalculateViewModel을 구현해 ViewController와 1:1 관계를 가지도록 설계했습니다.
- 입력한 데이터로 계산을 진행하는 비즈니스 로직을 구현하고 MainViewModel과 동일하게 단방향 흐름을 지키도록 설계했습니다.


</div>
</details>


<details>
<summary>LEVEL 06</summary>

### Level 6 - MVVM 패턴을 도입하여 View와 로직을 분리
- 이미 MVVM 구조가 잘 정립되어 있어, 별도의 수정 없이 주석만 추가하여 각 역할을 명확히 표시했습니다.

</details>

<details>
<summary>LEVEL 07</summary>

### Level 7 - 즐겨찾기 기능 상단 고정
- 북마크 버튼을 터치하면 이벤트가 발생하여 새로운 CoreData Entity를 저장하고, 최신 데이터를 다시 리스트업합니다.
- `PersistentManager`를 구현하여 NSPersistentContainer 및 context를 정의했습니다.
- CoreData의 CRUD 기능은 다음과 같이 구성했습니다:
  - 전체 환율 항목 fetch
  - 특정 항목 fetch
  - 항목 수정 (ex. 북마크 상태 변경)
  - 새 항목 저장
- 추후 요구사항을 고려하여 환율 전체 데이터를 CoreData에 캐싱할 수 있도록 설계했습니다.

</details>

<details>
<summary>LEVEL 08</summary>

### Level 8 - 상승 🔼 하락 🔽  여부 표시
- UserDefaults를 사용해 마지막 업데이트 날짜를 저장하고, 날짜 변경을 감지하면 캐싱된 데이터와 새 데이터의 차이를 계산합니다.
- CoreData 내 DTO와 앱 내부에서 사용할 Entity(Model)를 명확히 분리했습니다 (용도와 컨텍스트 관리 목적).
- 전날 데이터와 새로 받아온 데이터를 비교하여 차이를 계산하고, rate 변화량을 저장했습니다.
- 특정 셀에 표시되는 아이콘은 `rateOfChange`가 ±0.01 이상인 경우에만 노출되도록 구현했습니다.

</details>

<details>
<summary>LEVEL 09</summary>

### Level 9 - 다크모드 구현
- 요구사항에 따른 색상 코드를 `Assets`에 등록했습니다.
- 각 색상은 코드에서 재사용할 수 있도록 `UIColor` 또는 `Color` extension으로 분리하여 정의했습니다.
- 이를 통해 UI 컴포넌트에서 일관된 방식으로 색상을 사용할 수 있도록 했습니다.

</details>

<details>
<summary>LEVEL 10</summary>

### Level 10 - 앱 상태 저장 및 복원 
- 셀 터치 시 혹은 앱이 백그라운드로 진입할 때 해당 상태를 CoreData에 저장합니다.
- 기존 환율 데이터의 CRUD와는 분리하여 `LastScreen` 전용 Entity로 관리했습니다.
- 화면 상태(`.list`, `.calculator`)와 관련된 통화 ID를 함께 저장하고, 앱 실행 시 `SceneDelegate`에서 불러와 복원하도록 구성했습니다.

</details>

<details>
<summary>LEVEL 11</summary>

### Level 11 -  메모리 이슈 디버깅 및 개선 경험 문서화
- Instruments의 `Profile > Leaks`를 통해 메모리 누수를 점검했고, 누수는 검출되지 않았습니다.
- RxSwift의 구독 클로저 내부에서 `self` 접근 시 `[weak self]`를 사용하여 순환 참조를 방지했습니다.

</details>

<details>
<summary>LEVEL 12</summary>

### Level 12 -  Clean Architecture 적용
- 클린 아키텍처 구조를 학습한 뒤 실제 프로젝트에 적용했습니다.
- 전체 구조는 다음과 같습니다

```
project-exchange-rate-calculator/
├── project-exchange-rate-calculator/
│   ├── Assets.xcassets/
│   │   └── ... (이미지 및 색상 리소스)
│   ├── Base.lproj/
│   │   └── LaunchScreen.storyboard
│   ├── Core/
│   │   ├── CoreData/
│   │   │   ├── CoreDataStack.swift
│   │   │   └── ... (코어데이터 관련 파일)
│   │   ├── Extension/
│   │   │   └── ... (확장 기능 파일)
│   │   ├── Manager/
│   │   │   └── UserDefaultManager.swift
│   │   └── Network/
│   │       └── ... (네트워크 관련 파일)
│   ├── Domain/
│   │   ├── Entity/
│   │   │   └── ExchangeRateModel.swift
│   │   ├── Repository/
│   │   │   └── ExchangeRateRepository.swift
│   │   └── UseCase/
│   │       └── FetchAPIExchangeRateUseCase.swift
│   ├── Presentation/
│   │   ├── Main/
│   │   │   ├── MainViewController.swift
│   │   │   └── MainViewModel.swift
│   │   └── ... (기타 프레젠테이션 계층 파일)
│   ├── Resources/
│   │   └── ... (리소스 파일)
│   ├── Supporting Files/
│   │   ├── Info.plist
│   │   └── ... (지원 파일)
│   └── project-exchange-rate-calculator.xcodeproj/
│       └── ... (Xcode 프로젝트 파일)
```

</details>

### 느낀점

```
예비군 훈련으로 인해 개발에 쓸 수 있는 시간이 충분하지 않았지만,
그만큼 시간을 더 밀도 있게 활용하려고 노력했습니다.
특히 클린 아키텍처를 도입하면서 구조적인 개발에 집중할 수 있었고,
변경과 확장이 쉬워져 짧은 시간 안에도 안정적으로 기능을 완성할 수 있었습니다.
그 과정에서 ‘구조가 개발의 생산성을 결정한다’는 걸 몸소 체감할 수 있었습니다.

이번에는 개발과 동시에 테스트 코드를 모두 작성하지는 못했지만 다음부턴 유닛테스트를 진행해
TDD 방식으로 프로젝트를 완성해보고 싶습니다.
```

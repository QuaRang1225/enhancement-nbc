## 🛠 기술 스택
- UIKit: UI 구성
- RxSwift / RxCocoa: 반응형 프로그래밍 적용
- MVVM/Clean Architecture: 뷰와 비즈니스 로직 분리 및 뷰 바인딩
- Swift concurrency: Json 데이터 디코딩 Manger에 적용
- Swift Testing: json 인코딩 실패케이스를 감지하기 위함(시간 부족으로 완벽히는 사용하지 못함)
- CoreData: 환율 데이터 및 스크린 상태 저장

## 📱 구현 사진




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

```swift

```

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

```swift

```

</div>
</details>

</div>
</details>

<details>
<summary>LEVEL 03</summary>
<div markdown="1">

### Level 3 - 필터링 기능 구현
- 텍스트 입력을 감지해 액션을 방출하는 케이스를 추가했습니다.

```swift

```

</div>
</details>

<details>
<summary>LEVEL 04</summary>
<div markdown="1">

### Level 4 - 환율 계산기로 이동
- 요구사항에 맞게 환율 계산기 버튼을 구현했습니다.
- 각 cell의 데이터를 새로운 ViewController로 넘겨 초기화하는 방식을 사용했습니다.

```swift

```

</div>
</details>

<details>
<summary>LEVEL 05</summary>
<div markdown="1">

### Level 5 - 입력한 금액 실시간 반영
- 새로운 CalculateViewModel을 구현해 ViewController와 1:1 관계를 가지도록 설계했습니다.
- 입력한 데이터로 계산을 진행하는 비즈니스 로직을 구현하고 MainViewModel과 동일하게 단방향 흐름을 지키도록 설계했습니다.

```swift

```

</div>
</details>


### 느낀점
```
이번 프로젝트에서는 구현 후 리팩토링에 집중했습니다.

RxSwift를 활용하여 컴포넌트 기반의 반응형 프로그래밍을 시도했지만, 목표했던 만큼 성과를 내지 못한 점이 아쉽습니다.
기능을 빠르게 개발한 후 리팩토링하는 과정에서 시간이 많이 소요되는 습관이 있는데, 물론 처음부터 완벽한 코드를 작성할 수는 없지만,
점차 그 시간을 줄일 필요가 있음을 느꼈습니다.

또한, 팀원들과의 코드 리뷰를 통해 많은 피드백을 받았고, 이를 바탕으로 스스로 성장할 수 있었던 프로젝트였습니다.
```

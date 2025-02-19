### 구현 내용

![Feb-19-2025 16-09-06](https://github.com/user-attachments/assets/ed73134d-4b8e-48a1-9577-0bdf205951b5)

 
- Memo : DTO 모델
- MemoView : UI 및 레이아웃 설정
- MemoViewController : UI 업데이트 및 여러 이벤트
- MemoViewModel : 비즈니스 로직
- HederView : 커스텀 컴포넌트 UI

> Model
- 테이블뷰에서 사용될 메모의 구성요소 정의

> HeaderView
- View 재사용성을 용이하게 하기 위해 커스텀 HeaderView 구현
- rightItem, leftItem, title이 존재하며 HeaderView가 필요한 곳에서 각각의 아이템 속성 재정의할 수 있음
- 크기 및 레이아웃 설정

> MemoView 구현
- 매모앱의 실제 컴포넌트들을 배치한 클래스
- tableView와 headerView 정의 및 레이아웃 설정

> ViewModel 구현
- 메모기능의 비즈니스 로직을 모아둔 클래스
- 데이터 저장, 삭제 ,불러오기, 업데이트 등의 기능 구현
- 기능 실행 후 ViewController에서 추가적으로 필요한 기능을 파라미터로 받아 사용하도록 구현

> MemoViewController 구현
- View와 ViewModel의 데이터 바인딩과, 실제 UI의 로직을 담당하는 클래스
- 버튼 타겟 설정, 알림기능 구현, 테이블뷰 속성정의 등 UI와 반응하는 메서드 구현
- 비즈니스로직이 실행된 후 UI에도 적용되도록 ViewModel과 데이터 바인딩


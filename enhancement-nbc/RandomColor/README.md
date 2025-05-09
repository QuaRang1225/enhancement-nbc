### 요구 사항
1. UIView: 화면 전체를 덮는 배경 영역.
2. UILabel: 중앙에 RGB 값을 표시.
3. UIButton: 화면 하단에 두 개의 버튼 배치.
- "Change Color" 버튼: 랜덤 색상 변경.
- "Reset" 버튼: 초기화.

### 완성 조건
1. 버튼 클릭 시 배경색이 랜덤으로 변경되고, RGB 값이 표시됩니다.
2. 초기화 버튼을 누르면 배경색이 흰색으로 변경됩니다.
3. 모든 UI 컴포넌트가 Auto Layout을 통해 화면에 적절히 배치됩니다.


### 구현 내용

![Feb-17-2025 13-27-19](https://github.com/user-attachments/assets/3edff192-d4f8-41b1-84f3-bda199f90e22)


- 기본 UI 구현
- 랜덤 색상 생성 기능 구현
- 초기화 기능 구현
- story board를 사용하지 않고, code base로 개발
- MVC 패턴 차용
  - Model : 색상의 변경에 따라 텍스트와 배경색을 제공
  - View : 실제 뷰에 표시될 컴포넌트 및 오토 레이아웃
  - Controller : 해당 뷰의 기능 관련 메서드를 제공(change, reset)



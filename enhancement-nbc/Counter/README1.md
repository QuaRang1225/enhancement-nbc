
### 요구 사항
1. UILabel:
- 화면 중앙에 현재 숫자를 표시합니다.
- 초기 값은 "0"으로 설정합니다.
2. UIButton:
- 하단에 "+" 버튼, "-" 버튼, "Reset" 버튼을 수평으로 배치합니다.
- 각각의 버튼은 각 기능(증가, 감소, 초기화)을 담당합니다.
3. Auto Layout:
- 모든 UI 컴포넌트는 Auto Layout을 사용해 배치합니다.
### 완성 조건
1. 버튼 클릭 시 숫자가 올바르게 증가/감소/초기화됩니다.
2. UI가 Auto Layout으로 적절히 배치되어 다양한 화면 크기에서 정상적으로 표시됩니다.

### 구현내용
![Feb-17-2025 18-20-12](https://github.com/user-attachments/assets/ce2ba483-b232-4a22-9d54-ab22475af309)

 

- 기본 UI 구현
- 카운터 +,- 기능 구현
- 초기화 기능 구현
- story board를 사용하지 않고, code base로 개발
- Extension으로 커스텀 modifier 추가(코드의 재사용성 용이)
- MVC 패턴 차용
   - Model : 실제 카운트 되는 num변수
   - View : 실제 뷰에 표시될 컴포넌트 및 오토 레이아웃
   - Controller : 해당 뷰의 기능 관련 메서드를 제공(plus,minus, reset)


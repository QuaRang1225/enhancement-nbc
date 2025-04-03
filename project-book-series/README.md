# LEVEL 04

## 📝 키포인트

### Summary 더보기 버튼에 따른 라벨 컨트롤
```swift
//MARK: 문자열을 종류별로 분리해 더보기 기능 구현
private func configExpandString(){
    let text = bookView.attributes[episode].summary
    let summary = String(text.prefix(450))
    let cut = String(text.dropFirst(450))
    if text.count > 450{
        bookView.expandButton.isHidden = false
        summaryAttributes = SummaryAttributes(text: summary + (isExpand ? cut : "..."),cut: cut)
    }else{
        bookView.expandButton.isHidden = true
        summaryAttributes = SummaryAttributes(text: text, cut: cut)
    }
    bookView.expandButton.setTitle(isExpand ? "접기" : "더보기", for: .normal)
    bookView.summaryStackView.content = summaryAttributes.text
}
```
- summary를 450자 기준으로 자른 데이터를 앞부분/뒷부분으로 나눔
- 만약 Summary가 512자라면 450자 텍스트와 62자로 나눠 변수에 저장
- 전체 텍스트가 450이상일 경우 자른 앞 450자 뒤에 "..." 문자열을 추가하고 더보기 버튼 hidden을 비활성화
- 전체 텍스트가 450자 이하일 경우 텍스트를 그대로 Summary 라벨에 추가하고 더보기 버튼 hidden을 활성화

### 더보기 버튼 타겟 설정 및 버튼 이벤트 메서드 구현
```swift
 //MARK: 버튼 타켓 설정
private func configureTarget(){
    bookView.expandButton.addTarget(self, action: #selector(toggleSummaryExpand), for: .touchUpInside)
}
//MARK: summary 더보기 버튼 이벤트
@objc private func toggleSummaryExpand(){
    isExpand.toggle()
    bookView.summaryStackView.content?.removeLast(isExpand ? 3 : summaryAttributes.cutCount)
    bookView.summaryStackView.content?.append(isExpand ? summaryAttributes.cut : "...")
    bookView.expandButton.setTitle(isExpand ? "접기" : "더보기", for: .normal)
}
```
- bookView의 버튼 타겟 설정
- 더보기 버튼 선택 시 isExpand(더보기/접기 여부)에 따라 마지막 문자열을 cut의 개수 혹은 ...의 길이 3칸을 삭제하고 반대의 경우에 해당하는 문자열을 추가
- 이벤트 실행 후버튼 텍스 변경

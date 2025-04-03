# LEVEL 03

## 📝 키포인트

### UIStack 메서드화
```swift
final class BookView:UIView{
  //MARK: Dedication & Summary 섹션/헤더 스택뷰
  private func frontVstackView(labels:[UILabel]) -> UIStackView{
      let view = UIStackView(arrangedSubviews:labels)
      labels.forEach{ $0.textAlignment = .left }
      view.axis = .vertical
      view.alignment = .leading
      view.spacing = 8
      return view
  }
  private func configureUI(){
      let dedication = frontVstackView(labels: [dedicationTitleLabel,dedicationLabel])
      let summary = frontVstackView(labels: [summaryTitleLabel,summaryLabel])

      dedication.snp.makeConstraints { make in
            make.top.equalTo(bookInfoHStackView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
      summary.snp.makeConstraints { make in
          make.top.equalTo(dedication.snp.bottom).offset(24)
          make.horizontalEdges.equalToSuperview().inset(20)
      }
  }
}
```
- 불필요한 스택 컴포넌트 선언을 줄이고 코드 재사용성을 높일 수 있음

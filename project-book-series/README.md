# LEVEL 02

## 📝 키포인트

### Custom Label 명시

```swift
//MARK: View의 라벨 중 내용에 해당하는 커스텀 컴포넌트
class UIContentLabel:UILabel{
    let fonts:UIFont
    let color:UIColor
    
    init(fonts:UIFont,color:UIColor) {
        self.fonts = fonts
        self.color = color
        super.init(frame: .zero)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure(){
        font = fonts
        textColor = color
        numberOfLines = 0
        textAlignment = .center
    }
}

final class BookView:UIView{
    
    //MARK: 각 타이틀에 따른 데이터 라벨
    private let authorLabel = UIContentLabel(fonts: .systemFont(ofSize: 18), color: .darkGray)
    private let realesLabel = UIContentLabel(fonts: .systemFont(ofSize: 14), color: .gray)
    private let pageLabel = UIContentLabel(fonts: .systemFont(ofSize: 14), color: .gray)
    .
    .
    .
}
```
- 라벨의 반복되는 속성 패턴을 파악해 UILabel을 커스텀으로 재정의
- Custom TitleLabel,ContentsLabel 구현
- View에서 컴포넌트를 정의하는 코드의 수를 줄이기 위함


### 날짜 변환 Extension 작성
```swift
extension String{
    func getAmericaDateFormatter() -> String{
        //입력 변환
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: self) else { return "" }
        
        //출력 변환
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM dd, yyyy"
        
        return outputFormatter.string(from: date)
    }
}
```
- 날짜 String 데이터를 요구사항에 맞춰서 변환하는 메서드 String에 구현
- [BookView.swift](https://github.com/QuaRang1225/enhancement-nbc/blob/65a11329a99f1bda39fdd3f0b6ede30232d59a8f/project-book-series/project-book-series/Book/BookView.swift#L118) 참고

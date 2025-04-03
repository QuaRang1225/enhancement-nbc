# LEVEL 04

## 📝 키포인트

### 커스텀 스택뷰 선언
```swift
//MARK: 커스텀 타이르/컨텐츠 스택 뷰
class UIArticleStackView:UIStackView{
    //MARK: 타이틀
    let title:String
    //MARK: 컨텐츠 변경 시 텍스트 업데이트
    var content:String?{
        didSet{
            configure()
        }
    }
    //MARK: 컨텐츠 리스트 변경 시 스택뷰 업데이트
    var contents:[String]?{
        didSet{
            configure()
        }
    }
    //MARK: 타이틀 라벨
    private lazy var titleLabel = UITitleLabel(text: title, size: 18)
    //MARK: 컨텐츠 라벨
    private lazy var contentLabel = UIContentLabel(font: .systemFont(ofSize: 14), color: .darkGray)
    //MARK: 컨텐츠 리스트 스택뷰
    private lazy var contentStackView:UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    init(title:String) {
        self.title = title
        super.init(frame: .zero)
        axis = .vertical
        spacing = 8
        alignment = .leading
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 단일 컨텐츠의 경우 text교체/리스트일 경우 스택뷰에서 전부 제거 후 새로 추가
    private func configure(){
        if let content {
            [titleLabel, contentLabel]
                .forEach{ addArrangedSubview($0) }
            contentLabel.text = content
        } else if let contents {
            contentStackView.removeFromSuperview()
            [titleLabel, contentStackView]
                .forEach{ addArrangedSubview($0) }
            contentStackView.arrangedSubviews
                .forEach {  $0.removeFromSuperview() }
            contents.forEach {
                contentStackView.addArrangedSubview(UIContentLabel(font: .systemFont(ofSize: 14), color: .darkGray,text: $0))
            }
        }
    }
}
```
- 요구사항에는 Dedication, Summary, Chapters 3가지의 타이틀/컨텐츠로 구현된 컴포넌트가 배치되어야함
- 3개의 컴포넌트는 모두 같은 속성의 타이틀 라벨과 내용 라벨을 가지기 때문에 이를 하나의 스택뷰로 표현하기 위해 커스텀 컴포넌트로 작성
- Dedication, Summary처럼 하나의 컨텐츠만 가지는 경우는 `content`값을, Chapters처럼 라벨이 여러개인 경우는 `contents`값을 업데이트
- 각각의 데이터가 업데이트 되었을 때 프로퍼티 옵저버로 스택뷰에 뷰를 add하는 로직

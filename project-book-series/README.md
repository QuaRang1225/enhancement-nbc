# LEVEL 07

## 📝 키포인트

### 포스터 이미지 선택 시 wiki데이터로 웹뷰 모달 표시
```swift
//MARK: 데이터를 영구적으로 저장하기 위한 매니저
final class UserDefaultsManagar{
    enum Mode:String{
        case expand
        case episode
    }
    //MARK: 싱글턴 인스턴스 생성
    static let shared = UserDefaultsManagar()
    
    func getData<T>(mode: Mode) -> T {
        guard let object = UserDefaults.standard.object(forKey: mode.rawValue) as? T else{
            switch mode {
            case .expand: return (false as! T)
            case .episode: return (0 as! T)
            }
        }
        return object
    }
    func setData<T:Codable>(mode:Mode,value:T){
        UserDefaults.standard.set(value, forKey: mode.rawValue)
    }
}
//포스터 이미지 터치
  @objc private func presentWebView(){
      let vc = WikiWebView(url: URL(string: vm.attributes[episode].wiki)!)
      vc.modalPresentationStyle = .formSheet
      present(vc, animated: true)
  }
```
- VC에서 URL로 formSheet 타입으로 웹뷰 모달 표시.

### fetchJson 기능 MVVM + RxSwift 적용
```swift
//MARK: VC 메서드
//뷰 바인딩
private func bindViewModel() {
    vm.fetchSubject
        .onNext((bookView.isHidden = false))
    vm.attributesSubject
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] attributes in
            self?.configureBookView(attributes)
            self?.configureCollectionViewDelegate()
            self?.configureExpandButton()
            self?.configureSummaryStackView()
        },onError: { [weak self] error in
            guard let dataError = error as? DataError else { return }
            self?.showError(dataError)
        })
        .disposed(by: disposeBag)
}
```
- bindViewModel

  - VC에서는 해당 메서드를 viewDidLoad 시 호출

  - ViewModel과 바인딩을 하는 메서드며, 위에서 설명한 것 처럼 fetchSubject의 이벤트를 방출

  - Void로 선언했음으로 .onNext()에는 빈()값을 emit
  - 그렇게 되면 기존의 subject는 이에 반응하여 fetchInfo를 실행

 

  - fetchAttributes에서 데이터를 불러오면 성패 여부에 따라 onNext 혹은 onError를 방출함
  - 그러면 VC에서 구독을 하고 subject의 값으로 원하는 이벤트 핸들링을 추가
  - 이때 이벤트는 MainScheduler에서 동작하기 때문에 순차적으로 실행

```swift
port Foundation
import RxSwift
import RxCocoa

final class BookViewModel {
    //MARK: 프로퍼티 선언
    //disposeBag - 메모리 누수 방지
    private let disposeBag = DisposeBag()
    //속성 배열
    public var attributes = [Attributes]()
    // 데이터 변경을 감지하는 Subject
    var attributesSubject = PublishSubject<[Attributes]>()
    // 데이터 로드를 트리거하는 Subject
    var fetchSubject = PublishSubject<Void>()
    
    init() {
        cofigureBindings()
    }
    // MARK: - 바인딩 설정
    private func cofigureBindings() {
        fetchSubject
            .subscribe(onNext: { [weak self] _ in
                self?.fetchAttributes()
            })
            .disposed(by: disposeBag)
    }
    // MARK: - JSON 데이터 로드
    private func fetchAttributes() {
        Task {
            do {
                let attributes = try await JsonManager.loadJson().get()
                self.attributes = attributes
                attributesSubject.onNext(attributes)
            } catch let error {
                attributesSubject.onError(error)
            }
        }
    }
}
```
- fetchAttributes

 

  - 해당 메서드는 필요 JSON 데이터 DTO로 디코딩해서 결과값&에러를 반환는 메서드

  - 해당 데이터를 불러오는 게 성공할 경우 Model에 저장하고 subject에 받아온 데이터를 emit

  - 실패 시, error를 emit

 

- cofigureBindings

 

- 헤당 메서드는 subject를 구독해 fetchAttributes를 실행하는 메서드

- viewmodel이 초기화 될 때, 해당 메서드를 실행시켜 바로 데이터를 Model에 저장

- 즉, fetchSubject에 이벤트가 들어오면 JSON 데이터를 불러오는 트리거 역할

- VC에서 데이터가 변경되면 onNext로 emit을 할때 반응할 수 있는 스트림을 구현

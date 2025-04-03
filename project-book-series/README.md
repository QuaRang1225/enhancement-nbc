# LEVEL 06

## 📝 키포인트

### 시리즈 버튼 컬렉션뷰로 변경
```swift
//MARK: 컬렉션뷰 컨트롤러 델리게이트
extension BookViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //MARK: 컬렉션 뷰 개수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bookView.attributes.count
    }
    //MARK: 컬렉션 뷰 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIEpisodeCell.identifier, for: indexPath) as? UIEpisodeCell else { return UICollectionViewCell() }
        cell.config(episode: indexPath.row)
        cell.selectedButton(indexPath.row == episode)
        return cell
    }
    //MARK: 컬렉션 뷰 선택 시 이벤트 설정
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isExpand = false
        episode = indexPath.row
        bookView.expandButton.setTitle("더보기", for: .normal)
        bookView.config(episode: episode)
        configExpandString()
    }
    //MARK: 컬렉션 뷰 가운데 정렬
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: Int = 40
        let cellCount = collectionView.numberOfItems(inSection: section)
        let totalCellWidth = cellWidth * cellCount
        let totalSpacing = (cellCount - 1) * 10
        let inset = (collectionView.frame.width - CGFloat(totalCellWidth) - CGFloat(totalSpacing))  / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}
```

- 커스텀 컬렉션 셀 정의 후 VC에서 delegate 및 datasource로 메서드 구현
- axis가 horixontal 일때 셀을 중앙 정렬하기 위해 각 셀과 padding 길이를 구해 양쪽에 padding
- 컬렉션뷰를 선택했을 때 View를 업데이트하도록 구현

### 프로퍼티 옵저버로 버튼 바인딩
```swift
//MARK: 데이터를 영구적으로 저장하기 위한 매니저
final class UserDefaultsManagar{
    enum Mode:String{
        case expand
        case summary
        case episode
    }
    //MARK: 싱글턴 인스턴스 생성
    static let shared = UserDefaultsManagar()
    
    func getData<T>(mode: Mode) -> T {
        guard let object = UserDefaults.standard.object(forKey: mode.rawValue) as? T else{
            switch mode {
            case .expand: return (false as! T)
            case .summary: return (SummaryAttributes() as! T)
            case .episode: return (0 as! T)
            }
        }
        return object
    }
    func setData<T:Codable>(mode:Mode,value:T){
        UserDefaults.standard.set(value, forKey: mode.rawValue)
    }
    func setEncodeData<T:Codable>(mode:Mode,value:T){
        if let value = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(value, forKey: mode.rawValue)
        }
    }
}

//MARK: 버튼 정보
private var episode:Int = UserDefaultsManagar.shared.getData(mode: .episode) {
    willSet{
        UserDefaultsManagar.shared.setData(mode: .episode, value: newValue)
    }
}
//MARK: 더보기/접기 여부
private var isExpand:Bool = UserDefaultsManagar.shared.getData(mode: .expand) {
    willSet{
        UserDefaultsManagar.shared.setData(mode: .expand, value: newValue)
    }
}
```
- 에피소드 버튼/더보기 버튼이 선택될 때마다 데이터를 UserDefaults에 저장하는 로직 구현
- 일관적으로 UserDefaults를 관리하기 위해 UserDefaultsManagar구현
- 커스텀 데이터 타입과 swift 기본 자료형을 분리하여 get 메서드 제레닉으로 구현(기본 자료형은 Codable이지만 디코딩 시 값이 다르게 나오기 때문)

//
//  FeedTableViewCell.swift
//  TTOON
//
//  Created by 임승섭 on 10/6/24.
//

import RxSwift
import UIKit

// tableViewCell 안에 collectionView 있는 형태
// tableViewCell 클래스 내에 collectionViewDataSource 연결.
// tableViewCell 내에 데이터를 알고 있어야 함
// tableViewCell의 setDesign 함수 내에 collectionView reload 코드 넣어주기


class FeedTableViewCell: BaseTableViewCell {
    var disablePrefetching: (() -> Void)?
    var enablePrefetching: (() -> Void)?
    
    var disposeBag = DisposeBag()
    
    
    // MARK: - UI
    let baseView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let profileImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 13
        view.image = UIImage(named: "sample1")
        return view
    }()
    
    let profileNameLabel = {
        let view = UILabel()
        view.font = .body14m
        view.text = "빨간 패딩을 입은 돼지"
        return view
    }()
    
    let menuImageView = {
        let view = UIImageView()
        view.image = TNImage.feedMenuButton
        return view
    }()
    
    let menuClearButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var diaryImageSwipeCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createDiaryImageSwipeCollectionViewLayout())
        view.register(BottomDiaryImageSwipeCollectionViewCell.self, forCellWithReuseIdentifier: BottomDiaryImageSwipeCollectionViewCell.description())
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.isPagingEnabled = false
        view.contentInsetAdjustmentBehavior = .never
        view.contentInset = Size.collectionViewContentInset
        view.decelerationRate = .fast
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.rx.didScroll
            .subscribe(onNext: { [weak self] in
                self?.disablePrefetching?()  // prefetching 비활성화
            })
            .disposed(by: disposeBag)

        view.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] in
                self?.enablePrefetching?()  // prefetching 활성화
            })
            .disposed(by: disposeBag)
        
        return view
    }()
    
    lazy var diaryImageSwipePageControl = {
        let view = UIPageControl()
        view.numberOfPages = 4
        view.hidesForSinglePage = true
        view.currentPageIndicatorTintColor = .tnOrange
        view.pageIndicatorTintColor = .grey03
        view.isEnabled = false
        return view
    }()
    
    let diaryTitleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.text = "한강 나들이"
        return view
    }()
    
    let diaryContentLabel = {
        let view = UILabel()
        view.font = .body14r
        view.numberOfLines = 0
        view.text = """
        오늘 날씨가 좋아서 오랜만에 한강으로 놀러가서 산책을 했다. 휴학하고 동기들을 오랜만에 보니 참 좋았다.
        날씨도 좋아서 산책하는 동안 너무 행복했다. 치킨도 시켜먹었는데 역시 치킨은 굽네가 제일 맛있다! 놀러가서 산책을 했다. 휴학하고 동기들을 오랜만에 보니 참 좋았다. 날씨도 좋아서 산책하는 동안 너무 행복했다.
        치킨도 시켜먹었는데 역시 치킨은 굽네가 제일 맛있다!
        """
        return view
    }()
    
    let diaryDateLabel = {
        let view = UILabel()
        view.font = .body12r
        view.text = "2024.00.00"
        view.textColor = .grey05
        return view
    }()
    
    let likeButton = {
        let view = UIButton()
        view.setImage(TNImage.feedHeartGray, for: .normal)
        return view
    }()
    
    let likeNumberButton = {
        let view = UIButton()
        view.setTitle("2", for: .normal)
        view.titleLabel?.font = .body12r
        view.setTitleColor(.grey06, for: .normal)
        return view
    }()
    
    
    // MARK: - Layout
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(baseView)
        
        [profileImageView,
         profileNameLabel,
         menuImageView,
         menuClearButton,
         diaryImageSwipeCollectionView,
         diaryImageSwipePageControl,
         diaryTitleLabel,
         diaryContentLabel,
         diaryDateLabel,
         likeButton,
         likeNumberButton
        ].forEach {
            baseView.addSubview($0)
        }
    }
    
    
    
    override func layouts() {
        super.layouts()
        
        // baseView
        baseView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(16)
            make.top.equalToSuperview()
        }
        
        // profile
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(26)
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(20)
        }
        
        menuImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(20)
        }
        menuClearButton.snp.makeConstraints { make in
            make.edges.equalTo(menuImageView).inset(-4)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(4)
            make.trailing.equalTo(menuImageView.snp.leading).offset(-4)
            make.centerY.equalTo(profileImageView)
        }
        
        
        // collectionView
        diaryImageSwipeCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.height.equalTo(Size.deviceWidth - 80)
        }
        
        diaryImageSwipePageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(diaryImageSwipeCollectionView.snp.bottom).offset(8)
        }
        
        
        // diary
        diaryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryImageSwipePageControl.snp.bottom).offset(22)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(23)
        }
        
        diaryContentLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            // 높이 유동적
        }
        
        diaryDateLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryContentLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        // likes
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(diaryDateLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(20)
            make.bottom.equalToSuperview().inset(28)    // bottom 설정
        }
        
        likeNumberButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.leading.equalTo(likeButton.snp.trailing)
        }
    }
    
    override func configures() {
        super.configures()
        
        contentView.backgroundColor = .grey01
        diaryImageSwipeCollectionView.dataSource = self
        diaryImageSwipeCollectionView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 위치 초기화
        diaryImageSwipeCollectionView.setContentOffset(CGPoint(x: -24, y: 0), animated: false)
        diaryImageSwipePageControl.currentPage = 0
        
        enablePrefetching?()
    }
}

// collectionView
extension FeedTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BottomDiaryImageSwipeCollectionViewCell.description(),
            for: indexPath
        ) as? BottomDiaryImageSwipeCollectionViewCell else
        {
            return UICollectionViewCell()
        }
        
        cell.imageView.backgroundColor = .red
        
        print(#function)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = FeedTableViewCell.Size.itemSize.width + FeedTableViewCell.Size.itemSpacing
        let idx = round(scrolledOffsetX / cellWidth)
        
        targetContentOffset.pointee = CGPoint(x: idx * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        // pageControl의 page 변경
        if diaryImageSwipePageControl.currentPage != Int(idx) {
            diaryImageSwipePageControl.currentPage = Int(idx)
        }
    }
}

// setDesign
extension FeedTableViewCell {
    func setDesign(_ model: FeedModel) {
        diaryTitleLabel.text = model.title
        diaryContentLabel.text = model.content
        diaryDateLabel.text = model.createdDate.toDate(to: .fullWithHyphen)?.toString(of: .fullWithDot)
        
        likeNumberButton.setTitle(String(model.like), for: .normal)
        
        // collectionViewDataSource를 사용하지 않고, 여기서 셀 디자인
        // (tableViewCell이 데이터를 물고 있지 않게 하기 위함)
//        for (idx, imageUrl) in model.imageList.enumerated() {
//            if let cell = diaryImageSwipeCollectionView.cellForItem(at: IndexPath(row: idx, section: 0)) as? BottomDiaryImageSwipeCollectionViewCell,
//               let url = URL(string: imageUrl) {
//                print("-- 이미지 로드 : \(url)")
//                cell.imageView.load(url: url)
//            }
//        }
    }
}



// Swipe CollectionView Layout
extension FeedTableViewCell {
    // Carousel 적용
    enum Size {
        // item size : 기기 - 양 옆 40, 정사각형
        // (tableViewCell이 양 옆 16 패딩. collectionViewCell이 그 안에서 24 패딩
        static let deviceWidth = UIScreen.main.bounds.width
        static let itemSize = CGSize(width: deviceWidth - 80, height: deviceWidth - 80)  // 아이템 크기 (정사각형)
        static let itemSpacing = 8.0 // 아이템과 아이템 사이 간격
        static let insetX = (deviceWidth - 12 - 16 - itemSize.width) / 2.0 // 아이템이 센터에 있을 때, 디바이스 기준 inset (여기선 테이블뷰 셀 기준 inset)
        static var collectionViewContentInset: UIEdgeInsets {
          UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
        }
    }
    
    private func createDiaryImageSwipeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Size.itemSize
        layout.minimumLineSpacing = Size.itemSpacing
        layout.minimumInteritemSpacing = 0
        
        return layout
    }
}

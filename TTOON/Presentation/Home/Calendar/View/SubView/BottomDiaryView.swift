//
//  BottomDiaryView.swift
//  TTOON
//
//  Created by 임승섭 on 7/19/24.
//

import UIKit

class BottomDiaryView: BaseView {
    // MARK: - UI Component
    let dateTitleLabel = {
        let view = UILabel()
        view.text = "2024년 5월 10일"
        view.font = .title20b
        return view
    }()
    let chevronRightImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(systemName: "chevron.right")
        view.tintColor = .black
        return view
    }()
    let clearButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    let diaryTitleLabel = {
        let view = UILabel()
        view.text = "한강 나들이"
        view.font = .body16b
        view.numberOfLines = 1 // TODO: -
        return view
    }()
    let diaryContentLabel = {
        let view = UILabel()
        view.text = "오늘 날씨가 좋아서 오랜만에 한강으로 놀러가서 산책을 했다. 휴학하고 동기들을 오랜만에 보니 참 좋았다. 날씨도 좋아서 산책하는 동안 너무 행복했다. 치킨도 시켜먹었는데 역시 치킨은 굽네가 맛있다! 오늘 날씨가 좋아서 오랜만에 한강으로 놀러가서 산책을 했다. 휴학하고 동기들을 오랜만에 보니 참 좋았다. 날씨!"
        view.font = .body14r
        view.textColor = .grey06
        view.numberOfLines = 0
        return view
    }()
    lazy var diaryImageSwipeCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createDiaryImageSwipeCollectionViewLayout())
//        view.backgroundColor = .red
        
        view.register(BottomDiaryImageSwipeCollectionViewCell.self, forCellWithReuseIdentifier: BottomDiaryImageSwipeCollectionViewCell.description())
        
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        
//        view.bounces = false // ?
//        view.alwaysBounceHorizontal = false // ?
        
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
    
    
    
    // MARK: - UI Layout
    override func addSubViews() {
        super.addSubViews()
        
        [dateTitleLabel, chevronRightImageView, clearButton, diaryTitleLabel, diaryContentLabel, diaryImageSwipeCollectionView, diaryImageSwipePageControl].forEach { item in
            self.addSubview(item)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        dateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(36.5)
            make.leading.equalTo(self).inset(16)
        }
        
        chevronRightImageView.snp.makeConstraints { make in
            make.height.equalTo(7)
            make.trailing.equalTo(self).inset(26)
            make.centerY.equalTo(dateTitleLabel)
        }
        
        diaryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTitleLabel.snp.bottom).offset(11)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
        diaryContentLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
        diaryImageSwipeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(diaryContentLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self)  // 여백은 CollectionView 자체에서.
            make.height.equalTo(diaryImageSwipeCollectionView.snp.width).offset(-32)
        }
        
        diaryImageSwipePageControl.snp.makeConstraints { make in
            make.top.equalTo(diaryImageSwipeCollectionView.snp.bottom).offset(12)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).inset(40)
        }
    }
    
    // MARK: - Setting
    override func configures() {
        super.configures()
        
        self.roundCorners(cornerRadius: 22, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner]) // 적용이 안된다...?
    }
}


// Swipe CollectionView Layout
extension BottomDiaryView {
    private func createDiaryImageSwipeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        // item size : 양 옆 16 패딩 + 정사각형
        let deviceWidth = UIScreen.main.bounds.width
        let itemSize = deviceWidth - 2 * 16
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        return layout
    }
}


// design View
extension BottomDiaryView {
    // 추후 Entity에 struct 만들어서 받을 예정
//    struct A {
//        let date: Date
//        let tilte: String
//        let content: String
//        let images: [String]
//    }
    
    func updateDate(_ date: Date) {
        dateTitleLabel.text = date.toString(of: .fullKorean)
    }
}

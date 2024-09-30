//
//  MakeImageViewManager.swift
//  TTOON
//
//  Created by 임승섭 on 9/30/24.
//

import Photos
import UIKit

class MakeImageViewManager {
    static let shared = MakeImageViewManager()
    private init() { }
    
    func saveImage(imageUrls: [String], type: SaveImageType) {
        switch type {
        case .fourPage:
            // 이미지 배열의 요소들을 각각 하나의 페이지로 저장
            imageUrls.forEach {
                makeImageView(
                    imageUrls: [$0],
                    type: .fourPage) { view in
                        print("saveIamge, fourPage")
                        UIImageWriteToSavedPhotosAlbum(view.asImage(), self, nil, nil)
                }
            }
            
        case .onePage:
            // 이미지 배열의 요소들을 합쳐서 하나의 페이지에 저장
            makeImageView(
                imageUrls: imageUrls,
                type: type) { view in
                    print("saveImage, onePage")
                    UIImageWriteToSavedPhotosAlbum(view.asImage(), self, nil, nil)
            }
        }
    }
    
    func shareImage(imageUrls: [String], type: SaveImageType) {
        switch type {
        case .fourPage:
            var imageList: [UIImage] = []
            
            let group = DispatchGroup()
            
            imageUrls.forEach {
                group.enter()
                makeImageView(imageUrls: [$0], type: .fourPage) { view in
                    imageList.append(view.asImage())
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                let activityVC = UIActivityViewController(activityItems: imageList, applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
            }
            
        case .onePage:
            makeImageView(imageUrls: imageUrls, type: type) { view in
                let activityVC = UIActivityViewController(activityItems: [view.asImage()], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
            }
        }
    }
    
    private func makeImageView(imageUrls: [String], type: SaveImageType, completion: @escaping (UIView) -> Void) {
        // 이미지 로드하는 데 시간이 걸릴 수 있기 때문에, 빈 이미지로 리턴되지 않도록 주의 => completion 활용
        // type이 onePage일 때는 imageUrl에 딱 하나만 들어온다.
        
        // UI Component
        let baseView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 328, height: 360))
            view.backgroundColor = .white
            return view
        }()
        let oneImageView = {
            let view = UIImageView()    // 한 장일 때
            view.contentMode = .scaleAspectFit
            return view
        }()
        let fourImageViews = {
            let views = [UIImageView(), UIImageView(), UIImageView(), UIImageView()]   // 네 장일 때
            views.forEach { $0.contentMode = .scaleAspectFit }
            return views
        }()
        let waterMark = {
            let view = UIImageView()
            view.image = TNImage.waterMark
            view.contentMode = .scaleAspectFill
            return view
        }()
        
        
        // addSubviews
        [oneImageView, waterMark].forEach{ baseView.addSubview($0) }
        fourImageViews.forEach{ baseView.addSubview($0) }
        
        
        // layouts
        baseView.snp.makeConstraints { make in
            make.height.equalTo(360)
            make.width.equalTo(328) // 154 + 154 + 8 + 8 + 4
        }
        
        switch type {
        case .onePage:
            // 크기는 전부 동일
            fourImageViews.forEach {
                $0.snp.makeConstraints { $0.size.equalTo(154) }
            }
            
            fourImageViews[0].snp.makeConstraints { make in
                make.leading.top.equalTo(baseView).inset(8)
                make.size.equalTo(154)
            }
            fourImageViews[1].snp.makeConstraints { make in
                make.trailing.top.equalTo(baseView).inset(8)
            }
            fourImageViews[2].snp.makeConstraints { make in
                make.leading.equalTo(baseView).inset(8)
                make.top.equalTo(fourImageViews[0].snp.bottom).offset(4)
            }
            fourImageViews[3].snp.makeConstraints { make in
                make.trailing.equalTo(baseView).inset(8)
                make.top.equalTo(fourImageViews[1].snp.bottom).offset(4)
            }
            waterMark.snp.makeConstraints { make in
                make.top.equalTo(fourImageViews[3].snp.bottom).offset(12)
                make.centerX.equalTo(baseView)
                make.bottom.equalTo(baseView).inset(12)
            }
            
        case .fourPage:
            oneImageView.snp.makeConstraints { make in
                make.top.horizontalEdges.equalTo(baseView).inset(8)
                make.height.equalTo(oneImageView.snp.width)
            }
            waterMark.snp.makeConstraints { make in
                make.top.equalTo(oneImageView.snp.bottom).offset(12)
                make.centerX.equalTo(baseView)
                make.bottom.equalTo(baseView).inset(12)
            }
        }
        
        baseView.layoutIfNeeded()
        
        // configure
        switch type {
        case .onePage:
            oneImageView.isHidden = true
            
            let group = DispatchGroup()
            for (i, item) in fourImageViews.enumerated() {
                group.enter()
                
                item.load(url: URL(string: imageUrls[i]), defaultImage: TNImage.userIcon) {
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                print("onePage, completion")
                completion(baseView)
            }
            
        case .fourPage:
            fourImageViews.forEach { $0.isHidden = true }
            
            oneImageView.load(url: URL(string: imageUrls.first ?? ""), defaultImage: TNImage.userIcon) {
                print("fourPage, completion")
                completion(baseView)
            }
        }
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

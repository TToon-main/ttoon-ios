//
//  ToonCreationToastView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/8/24.
//

import UIKit

import RxCocoa
import RxSwift

class ToonCreationToastView: BaseView {
    lazy var status: CreateToonStatus = .ing {
        didSet {
            setUI(status)
        }
    }
    
    var imageUrls: [String] = []
    
    private enum Color {
        static var gradientColors = [
            UIColor.tnOrange,
            UIColor.tnOrange.withAlphaComponent(0.7),
            UIColor.tnOrange.withAlphaComponent(0.4),
            UIColor.tnLightGreen.withAlphaComponent(0.3),
            UIColor.tnLightGreen.withAlphaComponent(0.7),
            UIColor.tnLightGreen.withAlphaComponent(0.3),
            UIColor.tnOrange.withAlphaComponent(0.4),
            UIColor.tnOrange.withAlphaComponent(0.7),
        ]
    }
    
    private enum Constants {
        static let gradientLocation = [Int](0..<Color.gradientColors.count)
            .map(Double.init)
            .map { $0 / Double(Color.gradientColors.count) }
            .map(NSNumber.init)
        static let cornerRadius = 28.0
        static let cornerWidth = 4.0
    }
    
    private var timer: Timer?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 56)
    }
    
    let creationIconImageView = {
        let view = UIImageView()
        view.image = TNImage.toonCreationIcon
        
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .body16m
        
        return view
    }()
    
    let upIconImageView = {
        let view = UIImageView()
        view.image = TNImage.arrowDown?.withTintColor(.white)
        view.transform = CGAffineTransform(rotationAngle: .pi * 3 / 2)
        
        return view
    }()
    
    let button = {
        let view = UIButton()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var container = {
        let view = UIStackView()
        view.spacing = 8
        view.addArrangedSubview(creationIconImageView)
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(upIconImageView)
        
        return view
    }()
    
    private let blurEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        
        return view
    }()
    
    override func configures() {
        backgroundColor = .black.withAlphaComponent(0.7)
        layer.cornerRadius = 28
        clipsToBounds = true
    }
    
    override func addSubViews() {
        addSubview(blurEffectView)
        addSubview(container)
        addSubview(button)
    }
    
    override func layouts() {
        blurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setUI(_ status: CreateToonStatus) {
        switch status {
        case .idle:
            button.isEnabled = false
            removeBorderGradation()

        case .ing:
            layer.borderWidth = 0
            creationIconImageView.isHidden = false
            upIconImageView.isHidden = true
            titleLabel.text = "아직 만화를 생성 중이에요!"
            button.isEnabled = false
            removeBorderGradation()
            
        case .complete(let urls):
            creationIconImageView.isHidden = true
            upIconImageView.isHidden = false
            titleLabel.text = "만화가 완성되었어요! 확인해보러 갈까요?!"
            button.isEnabled = true
            imageUrls = urls
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.animateBorderGradation()
            }
        }
    }
    
    func animateBorderGradation() {
        // 1. 경계선에만 색상을 넣기 위해서 CAShapeLayer 인스턴스 생성
        let shape = CAShapeLayer()
        
        // 경계선이 뷰의 경계와 일치하도록 path 설정
        shape.path = UIBezierPath(
            roundedRect: self.bounds.insetBy(dx: Constants.cornerWidth / 2, dy: Constants.cornerWidth / 2),
            cornerRadius: self.layer.cornerRadius - Constants.cornerWidth / 2
        ).cgPath
        
        shape.lineWidth = Constants.cornerWidth
//        shape.cornerRadius = Constants.cornerRadius
        shape.cornerRadius = layer.cornerRadius + Constants.cornerRadius
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        // 2. conic 그라데이션 효과를 주기 위해서 CAGradientLayer 인스턴스 생성 후 mask에 CAShapeLayer 대입
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.width + 8,
            height: self.bounds.height + 8 // 높이를 8만큼 늘림
        )
        
        gradient.type = .conic
        gradient.colors = Color.gradientColors.map(\.cgColor) as [Any]
        gradient.locations = Constants.gradientLocation
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.mask = shape
        
        // 그라데이션 레이어를 뷰의 레이어 위에 추가하여 애니메이션을 위로 위치시킴
        self.layer.addSublayer(gradient)
    
        // 3. 매 0.2초마다 마치 circular queue처럼 색상을 번갈아서 바뀌도록 구현
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            gradient.removeAnimation(forKey: "myAnimation")
            let previous = Color.gradientColors.map(\.cgColor)
            let last = Color.gradientColors.removeLast()
            Color.gradientColors.insert(last, at: 0)
            let lastColors = Color.gradientColors.map(\.cgColor)
            
            let colorsAnimation = CABasicAnimation(keyPath: "colors")
            colorsAnimation.fromValue = previous
            colorsAnimation.toValue = lastColors
            colorsAnimation.repeatCount = 1
            colorsAnimation.duration = 0.2
            colorsAnimation.isRemovedOnCompletion = false
            colorsAnimation.fillMode = .both
            gradient.add(colorsAnimation, forKey: "myAnimation")
        }
    }


    
    func removeBorderGradation() {
        self.timer?.invalidate()
        self.timer = nil
        self.layer.removeAnimation(forKey: "myAnimation")
    }
}


extension Reactive  where Base: ToonCreationToastView {
    var buttonTap: Observable<[String]> {
        return base.button.rx.tap
            .map { _ in base.imageUrls}
            .filter { !$0.isEmpty }
    }
}

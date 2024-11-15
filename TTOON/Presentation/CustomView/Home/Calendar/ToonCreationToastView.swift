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
    var model: SaveToon?
    
    lazy var status: CreateToonStatus = .ing {
        didSet {
            setUI(status)
        }
    }
    
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
            
        case .complete(let model):
            creationIconImageView.isHidden = true
            upIconImageView.isHidden = false
            titleLabel.text = "만화가 완성되었어요! 확인해보러 갈까요?"
            button.isEnabled = true
            self.model = model
            animateBorderGradation()
        }
    }
    
    private func animateBorderGradation() {
        layoutIfNeeded()
    
        let gradientLayer = createGradientLayer()
        layer.addSublayer(gradientLayer)
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            gradientLayer.removeAnimation(forKey: "myAnimation")
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
            gradientLayer.add(colorsAnimation, forKey: "myAnimation")
        }
    }


    
    private func removeBorderGradation() {
        self.timer?.invalidate()
        self.timer = nil
        self.layer.removeAnimation(forKey: "myAnimation")
    }
    
    private func createShapeLayer() -> CAShapeLayer {
        let shape = CAShapeLayer()
        

        shape.path = UIBezierPath(
            roundedRect: self.bounds.insetBy(dx: Constants.cornerWidth / 2, dy: Constants.cornerWidth / 2),
            cornerRadius: self.layer.cornerRadius - Constants.cornerWidth / 2
        ).cgPath
        
        shape.lineWidth = Constants.cornerWidth
        shape.cornerRadius = layer.cornerRadius + Constants.cornerRadius
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor

        return shape
    }
    
    private func createGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        
        gradient.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.width + 8,
            height: self.bounds.height + 8
        )
        
        gradient.type = .conic
        gradient.colors = Color.gradientColors.map(\.cgColor) as [Any]
        gradient.locations = Constants.gradientLocation
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.mask = createShapeLayer()
        
        return gradient
    }
}


extension Reactive  where Base: ToonCreationToastView {
    var buttonTap: Observable<SaveToon> {
        return base.button.rx.tap
            .compactMap { _ in base.model}
    }
}

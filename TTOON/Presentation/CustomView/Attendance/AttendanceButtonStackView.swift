//
//  AttendanceButtonStackView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import UIKit

class AttendanceButtonStackView: BaseView {
    enum AttendanceButtonStackType {
        case firstLine
        case secondLine
        case thirdLine
    }
    
    var type: AttendanceButtonStackType
    
    let firstButton = {
        let view = AttendanceButton()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    let secondButton = {
        let view = AttendanceButton()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    let thirdButton = {
        let view = AttendanceButton()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private lazy var container = {
        let view = UIStackView()
        view.alignment = .top
        view.distribution = .equalSpacing 
        view.addArrangedSubview(firstButton)
        view.addArrangedSubview(secondButton)
        view.addArrangedSubview(thirdButton)
        
        return view
    }()
    
    init(type: AttendanceButtonStackType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubViews() {
        addSubview(container)
    }
    
    override func layouts() {
        container.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
    } 
    
    override func configures() {
        setStackType()
    }
    
    func setStackType() {
        switch type {
        case .firstLine:
            firstButton.selectedImage = TNImage.monOnIcon
            firstButton.unSelectedImage = TNImage.monOffIcon
            secondButton.selectedImage = TNImage.tueOnIcon
            secondButton.unSelectedImage = TNImage.tueOffIcon
            
        case .secondLine:
            firstButton.selectedImage = TNImage.wedOnIcon
            firstButton.unSelectedImage = TNImage.wedOffIcon
            secondButton.selectedImage = TNImage.thuOnIcon
            secondButton.unSelectedImage = TNImage.thuOffIcon
            thirdButton.selectedImage = TNImage.friOnIcon
            thirdButton.unSelectedImage = TNImage.friOffIcon
            
        case .thirdLine:
            secondButton.selectedImage = TNImage.satOnIcon
            secondButton.unSelectedImage = TNImage.satOffIcon
            thirdButton.selectedImage = TNImage.sunOnIcon
            thirdButton.unSelectedImage = TNImage.sunOffIcon
        }
    }
    
    override func layoutSubviews() {
        DispatchQueue.main.async {
            self.drawConnections()
        }
    }
}

extension AttendanceButtonStackView {
    func drawConnections() {
        switch type {
        case .firstLine: 
            drawFirstHorizontalLine()
            drawFirstCurveLine()
            drawFirstVerticalLine()
            
        case .secondLine:
            drawSecondHorizontalLine()
            drawSecondVerticalLine()
            
        case .thirdLine:
            drawThirdCurveLine()
            drawThirdHorizontalLine()
        }
    }
    
    private func addLineLayer(path: UIBezierPath) {
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.grey03.cgColor
        lineLayer.lineWidth = 6.0
        lineLayer.fillColor = UIColor.clear.cgColor
        
        layer.insertSublayer(lineLayer, at: 0)
    }
    
    private func drawFirstHorizontalLine() {
        let linePath = UIBezierPath()
        
        let startX = firstButton.frame.midX
        let startY = firstButton.frame.midY
        
        let endX = thirdButton.frame.minX
        let endY = secondButton.frame.midY
        
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        
        addLineLayer(path: linePath)
    }
    
    private func drawFirstCurveLine() {
        let linePath = UIBezierPath()
        
        let startX = thirdButton.frame.minX
        let startY = thirdButton.frame.midY
        
        let endX = thirdButton.frame.midX
        let endY = thirdButton.frame.maxY
        
        let curveX = thirdButton.frame.midX
        let curveY = thirdButton.frame.midY
        
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        let curvePoint = CGPoint(x: curveX, y: curveY) 
        
        linePath.move(to: startPoint)
        linePath.addQuadCurve(to: endPoint, controlPoint: curvePoint)
        
        addLineLayer(path: linePath)
    }
    
    func drawFirstVerticalLine() {
        let linePath = UIBezierPath()
        
        let startX = thirdButton.frame.midX
        let startY = thirdButton.frame.maxY 
        
        let endX = thirdButton.frame.midX
        let endY = thirdButton.frame.maxY + 20
        
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        
        addLineLayer(path: linePath)
    }
    
    private func drawSecondHorizontalLine() {
        let linePath = UIBezierPath()
        
        let startX = firstButton.frame.midX
        let startY = firstButton.frame.midY
        
        let endX = thirdButton.frame.midX
        let endY = thirdButton.frame.midY
        
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        
        addLineLayer(path: linePath)
    }
    
    func drawSecondVerticalLine() {
        let linePath = UIBezierPath()
        
        let startX = firstButton.frame.midX
        let startY = thirdButton.frame.maxY
        
        let endX = firstButton.frame.midX
        let endY = thirdButton.frame.maxY + 20 
        
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        
        addLineLayer(path: linePath)
    }
    
    
    private func drawThirdCurveLine() {
        let linePath = UIBezierPath()
        
        let startX = firstButton.frame.midX
        let startY = firstButton.frame.minY
        
        let endX = firstButton.frame.maxX 
        let endY = firstButton.frame.midY
        
        let curveX = firstButton.frame.midX
        let curveY = firstButton.frame.midY
        
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        let curvePoint = CGPoint(x: curveX, y: curveY) 
        
        linePath.move(to: startPoint)
        linePath.addQuadCurve(to: endPoint, controlPoint: curvePoint)
        
        addLineLayer(path: linePath)
    }
    
    private func drawThirdHorizontalLine() {
        let linePath = UIBezierPath()
        
        let startX = firstButton.frame.maxX
        let startY = firstButton.frame.midX
        
        let endX = secondButton.frame.minX 
        let endY = firstButton.frame.midX
        
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY) 
        
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        
        addLineLayer(path: linePath)
    }
}

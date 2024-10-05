//
//  AttendanceButtonStackView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import UIKit

class AttendanceButtonStackView: BaseView {
    // MARK: - Custom Type
    
    enum AttendanceButtonStackType {
        case firstLine
        case secondLine
        case thirdLine
    }
    
    // MARK: - Properties
    
    var type: AttendanceButtonStackType
    
    // MARK: - UI Properties
    
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
    
    // MARK: - Initialize
    
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
    
    // MARK: - Configurations
    
    override func layouts() {
        container.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
    } 
    
    override func layoutSubviews() {
        DispatchQueue.main.async {
            self.drawConnections()
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
}

extension AttendanceButtonStackView {
    func drawConnections() {
        switch type {
        case .firstLine:
            drawLine(startX: firstButton.frame.midX, startY: firstButton.frame.midY,
                      endX: thirdButton.frame.minX, endY: secondButton.frame.midY)
            drawCurve(startX: thirdButton.frame.minX, startY: thirdButton.frame.midY,
                      endX: thirdButton.frame.midX, endY: thirdButton.frame.maxY,
                      controlX: thirdButton.frame.midX, controlY: thirdButton.frame.midY)
            drawVerticalLine(startX: thirdButton.frame.midX, startY: thirdButton.frame.maxY,
                             endX: thirdButton.frame.midX, endY: thirdButton.frame.maxY + 20)

        case .secondLine:
            drawLine(startX: firstButton.frame.midX, startY: firstButton.frame.midY,
                      endX: thirdButton.frame.midX, endY: thirdButton.frame.midY)
            drawVerticalLine(startX: firstButton.frame.midX, startY: thirdButton.frame.maxY,
                             endX: firstButton.frame.midX, endY: thirdButton.frame.maxY + 20)

        case .thirdLine:
            drawCurve(startX: firstButton.frame.midX, startY: firstButton.frame.minY,
                       endX: firstButton.frame.maxX, endY: firstButton.frame.midY,
                       controlX: firstButton.frame.midX, controlY: firstButton.frame.midY)
            drawLine(startX: firstButton.frame.maxX, startY: firstButton.frame.midY,
                      endX: secondButton.frame.minX, endY: firstButton.frame.midY)
        }
    }

    private func drawLine(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        let linePath = UIBezierPath()
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)

        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        addLineLayer(path: linePath)
    }

    private func drawCurve(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat,
                           controlX: CGFloat, controlY: CGFloat) {
        let curvePath = UIBezierPath()
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        let controlPoint = CGPoint(x: controlX, y: controlY)

        curvePath.move(to: startPoint)
        curvePath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        addLineLayer(path: curvePath)
    }

    private func drawVerticalLine(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        drawLine(startX: startX, startY: startY, endX: endX, endY: endY)
    }

    private func addLineLayer(path: UIBezierPath) {
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.grey03.cgColor
        lineLayer.lineWidth = 6.0
        lineLayer.fillColor = UIColor.clear.cgColor

        layer.insertSublayer(lineLayer, at: 0)
    }
}

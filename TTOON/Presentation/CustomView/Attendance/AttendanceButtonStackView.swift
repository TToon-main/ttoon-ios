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
    
    let firstButton = {
        let view = AttendanceButton()
        
        return view
    }()
    
    let secondButton = {
        let view = AttendanceButton()
        
        return view
    }()
    
    let thirdButton = {
        let view = AttendanceButton()
        
        return view
    }()
    
    private lazy var container = {
        let view = UIStackView()
        view.distribution = .equalSpacing 
        view.addArrangedSubview(firstButton)
        view.addArrangedSubview(secondButton)
        view.addArrangedSubview(thirdButton)
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(container)
    }
    
    override func layouts() {
        container.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
    } 
    
    func setStackType(_ type: AttendanceButtonStackType) {
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

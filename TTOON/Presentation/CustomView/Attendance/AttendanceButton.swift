//
//  AttendanceButton.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import UIKit

import RxSwift

class AttendanceButton: UIButton {
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 108, height: 108)
    }
    
    var selectedImage: UIImage? {
        didSet {
            setImage(selectedImage, for: .selected)
        }
    }
    
    var unSelectedImage: UIImage? {
        didSet {
            setImage(unSelectedImage, for: .normal)
        }
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
    // MARK: - Configurations
    
    private func configure() {
        layer.cornerRadius = 54
    }
}

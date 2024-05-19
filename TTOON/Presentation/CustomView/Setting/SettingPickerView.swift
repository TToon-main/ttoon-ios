//
//  SettingShowBottomSheetView.swift
//  TTOON
//
//  Created by 임승섭 on 5/18/24.
//

import FlexLayout
import PinLayout
import UIKit

class SettingPickerView: BaseView {
    // MARK: - Properties
    var initialText = "" {
        didSet {
            self.textLabel.text = initialText
        }
    }
    
    // MARK: - UI Components
    var textLabel = {
        let view = UILabel()
        view.font = .body16m
        return view
    }()
    
    private let chevronImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.down")?.withTintColor(.grey08)
        view.tintColor = .grey08
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let clearButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    
    convenience init(_ initialText: String) {
        self.init()
        
        self.initialText = initialText
        self.textLabel.text = initialText
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        [textLabel, chevronImageView, clearButton].forEach { item in
            addSubview(item)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chevronImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(16)
        }
        
        textLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).inset(20)
            make.trailing.equalTo(chevronImageView.snp.leading).inset(8)
        }
        
        clearButton.snp.makeConstraints { make in
            make.size.equalTo(self)
        }
    }
    
    override func configures() {
        super.configures()
        
        backgroundColor = .grey01
        
        clipsToBounds = true
        layer.cornerRadius = 8
    }
}

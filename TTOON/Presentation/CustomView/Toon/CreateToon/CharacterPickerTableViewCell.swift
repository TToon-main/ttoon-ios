//
//  CharacterPickerTableViewCell.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/13/24.
//

import UIKit

import RxCocoa
import RxSwift

struct CharacterPickerTableViewCellDataSource {
    let id: String
    let name: String
    let isMainCharacter: Bool
    let characterDescription: String
    var isSelected: Bool
    let isModify: Bool
}

class CharacterPickerTableViewCell: BaseTableViewCell {
    enum CellType {
        case pick
        case modify
    }
    
    var currentItem: CharacterPickerTableViewCellDataSource?
    var disposeBag = DisposeBag()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .body16b
        view.textColor = .grey08
        
        return view
    }()
    
    private let mainCharacterButton = {
        let view = UIButton()
        view.backgroundColor = .tnOrangeOff
        view.setTitle("메인 캐릭터", for: .normal)
        view.setTitleColor(.tnOrange, for: .normal)
        view.titleLabel?.font = .body12sb
        view.contentHorizontalAlignment = .center
        view.contentVerticalAlignment = .center
        view.layer.cornerRadius = 6
        
        return view
    }()
    
    private let subTitleLabel = {
        let view = UILabel()
        view.font = .body14r
        view.textColor = .grey07
        view.numberOfLines = 2
        
        return view
    }()
    
    private let checkImageView = {
        let view = UIImageView()
        view.image = TNImage.doneRound
        
        return view
    }()
    
    let modifyCharacterButton = {
        let view = UIButton()
        view.setTitle("수정하기", for: .normal)
        view.setTitleColor(.grey05, for: .normal)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 9, weight: .regular, scale: .default)
        let image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.semanticContentAttribute = .forceRightToLeft
        view.tintColor = .grey05
        view.titleLabel?.font = .body14m
        
        return view
    }()
    
    private let lineDiver = {
        let view = UIView()
        view.backgroundColor = .grey01
        
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        currentItem = nil
    }
    
    override func configures() {
        selectionStyle = .none
        contentView.clipsToBounds = true
    }
    
    override func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainCharacterButton)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(checkImageView)
        contentView.addSubview(modifyCharacterButton)
        contentView.addSubview(lineDiver)
    }

	override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    func setCell(_ item: CharacterPickerTableViewCellDataSource, cellType: CellType = .pick) {
        currentItem = item
        
        switch cellType {
        case .pick:
            titleLabel.text = item.name
            subTitleLabel.text = item.characterDescription
            modifyCharacterButton.isHidden = !item.isModify
            mainCharacterButton.isHidden = !item.isMainCharacter
            setIsSelected(item.isSelected)
            
        case .modify:
            titleLabel.text = item.name
            subTitleLabel.text = item.characterDescription
            mainCharacterButton.isHidden = !item.isMainCharacter
            modifyCharacterButton.isHidden = false
            checkImageView.isHidden = true
        }
    }
    
    private func setIsSelected(_ isSelected: Bool) {
        checkImageView.isHidden = !isSelected
        
        if isSelected {
            titleLabel.textColor = .grey08
            subTitleLabel.textColor = .grey07
        } else {
            [titleLabel, subTitleLabel].forEach { t in
                t.textColor = .grey05
            }
        }
    }
    
    override func layouts() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(mainCharacterButton)
        }
        
        mainCharacterButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(checkImageView.snp.leading).offset(-61)
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(25)
            $0.width.equalTo(71)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(checkImageView.snp.leading).offset(-61)
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        modifyCharacterButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(mainCharacterButton)
        }
        
        lineDiver.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Custom Observable

extension Reactive where Base: CharacterPickerTableViewCell {
    var modifyButtonTap: Observable<ModifyCharacter> {
        return base.modifyCharacterButton.rx.tap
            .map{ _ in return base.currentItem }
            .compactMap{ $0 }
            .map{ .init(id: $0.id, name: $0.name, info: $0.characterDescription) }
            .asObservable()
    }
}

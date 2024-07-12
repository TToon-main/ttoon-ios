//
//  CreateLoadingView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/24/24.
//

import UIKit

import Lottie
import SnapKit

class CreateLoadingView: BaseView {
    var progressLabelLeading: Constraint?
    
    let createAnimationView = {
        let view = LottieAnimationView(name: "toonLottie")
        view.loopMode = .loop
        view.play()
        
        return view
    }()
    
    let progressBar = {
        let view = UIProgressView()
        view.progress = 0.5
        view.progressTintColor = .tnOrange
        view.backgroundColor = .grey01
        
        return view
    }()
    
    lazy var progressLabel = {
        let view = UILabel()
        view.text = toProgressText(progressBar.progress)
        view.textAlignment = .center
        view.font = .body12r
        view.textColor = .white
        view.backgroundColor = .tnGreen
        
        return view
    }()
    
    let subTitleLabel = {
        let view = CreateToonSubTitleLabel()
        view.text = "써주신 일기 내용을 바탕으로\n만화를 그리는 중이에요!"
        view.textAlignment = .center
        view.numberOfLines = 0
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(createAnimationView)
        addSubview(progressBar)
        addSubview(progressLabel)
        addSubview(subTitleLabel)
    }
    
    override func layouts() {
        createAnimationView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(height * 0.25)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(134)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(createAnimationView.snp.bottom).offset(55)
            $0.horizontalEdges.equalToSuperview().inset(72)
            $0.height.equalTo(12)
        }
        
        progressLabel.snp.makeConstraints {
            $0.bottom.equalTo(progressBar.snp.top).offset(-4)
            $0.width.equalTo(28)
            $0.height.equalTo(20)
            progressLabelLeading = $0.leading.equalTo(progressBar.snp.leading).inset(12).constraint
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(86)
        }
    }
    
    func updateProgress(_ progress: Float) {
        progressBar.progress = progress
        let progressOffset = progressBar.bounds.width * CGFloat(progress)
        let offset = 72 - (progressLabel.bounds.width / 2) + progressOffset
        progressLabelLeading?.update(offset: offset)
        progressLabel.text = toProgressText(progress)
        layoutIfNeeded()
    }
    
    func toProgressText(_ progress: Float) -> String {
        let progress = Int(progress * 100)
        return "\(progress)%"
    }
}

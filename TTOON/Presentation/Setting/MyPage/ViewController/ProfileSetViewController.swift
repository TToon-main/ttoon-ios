//
//  ProfileSetViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import PhotosUI
import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class ProfileSetViewController: BaseViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    private let profileSetView = ProfileSetView()
    
    // MARK: - Init
    init(profileSetReactor: ProfileSetReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = profileSetReactor 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    override func loadView() {
        view = profileSetView
    }
    
    override func configures() {
        setNavigationItem()
        hideKeyboardWhenTappedAround()
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "프로필 설정"
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self 
        
        present(pickerViewController, animated: true)
    }
    
    private func presentCamera() {
        let pickerViewController = UIImagePickerController()
        pickerViewController.sourceType = .camera
        pickerViewController.delegate = self
        
        present(pickerViewController, animated: true)
    }
}

extension ProfileSetViewController: View {
    func bind(reactor: ProfileSetReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    func bindAction(_ reactor: ProfileSetReactor) {
        rx.viewWillAppear
            .map { _ in ProfileSetReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileSetView.rx.copyButtonTap
            .map { ProfileSetReactor.Action.copyButtonTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileSetView.rx.textFiledText
            .map { ProfileSetReactor.Action.nickName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileSetView.rx.changeImageButtonTap
            .map { ProfileSetReactor.Action.changeImageButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ProfileSetReactor) {
        reactor.state
            .compactMap { $0.profileInfo }
            .bind(to: profileSetView.rx.model)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.truncatedText }
            .bind(to: profileSetView.rx.truncatedText)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.errorMessage }
            .bind(to: profileSetView.nickNameTextFiled.rx.errorMassage)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.presentImagePicker }
            .bind(onNext: presentImagePicker)
            .disposed(by: disposeBag)
    }
}

extension ProfileSetViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let provider = results.first?.itemProvider{
            if provider.canLoadObject(ofClass: UIImage.self){
                provider.loadObject(ofClass: UIImage.self) { image, error  in
                    if let error{
                        print(error)
                    }
                    
                    if let selectedImage = image as? UIImage{
                        DispatchQueue.main.async {
                            self.profileSetView.profileImageView.image = selectedImage
                        }
                    }
                }
            }
        }
    }
}

extension ProfileSetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.profileSetView.profileImageView.image = selectedImage
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

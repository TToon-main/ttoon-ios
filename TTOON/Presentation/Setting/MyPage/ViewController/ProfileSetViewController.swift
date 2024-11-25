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
    var imageDidChanged = PublishSubject<Void>()
    var imageDidDeleted = PublishSubject<Bool>()
    
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
    
    private func pop() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProfileSetViewController: View {
    func bind(reactor: ProfileSetReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    func bindAction(_ reactor: ProfileSetReactor) {
        rx.viewDidLoad
            .map { _ in ProfileSetReactor.Action.viewDidLoad }
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
        
        profileSetView.rx.saveButtonTap
            .map { ProfileSetReactor.Action.saveButtonTap($0)  }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        imageDidChanged
            .map { ProfileSetReactor.Action.imageDidChanged }
            .do { _ in self.profileSetView.hideSkeleton() }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        imageDidDeleted
            .map { ProfileSetReactor.Action.imageDidDeleted($0)}
            .do { _ in self.profileSetView.hideSkeleton() }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ProfileSetReactor) {
        reactor.state
            .compactMap { $0.profileInfo }
            .delay(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .do { _ in self.profileSetView.hideSkeleton() }
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
            .bind(onNext: presentSetProfileImageActionSheetVC)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isSaveButtonEnabled }
            .bind(to: profileSetView.rx.isEnabledSaveButton)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.pop }
            .map { _ in return }
            .bind(onNext: pop)
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
                            self.imageDidChanged.onNext(())
                            self.imageDidDeleted.onNext(false)
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
                self.imageDidChanged.onNext(())
                self.imageDidDeleted.onNext(false)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 이미지 변경과 관련된 액션

extension ProfileSetViewController {
    private func presentSetProfileImageActionSheetVC() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "사진 찍기", style: .default) { action in
            AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    switch status {
                    case true:
                        self.presentCamera()
                        self.profileSetView.showSkeleton()

                    case false:
                        TNAlert(self)
                            .setTitle("카메라 권한을 확인해주세요.")
                            .setSubTitle("설정 앱에서 권한을 변경하시겠습니까?")
                            .addConfirmAction("확인") {
                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsURL)
                                }
                            } 
                            .addCancelAction("취소")
                            .present()
                    }
                }
            }
        }
        
        actionSheet.addAction(takePhotoAction)
        
        let chooseImageAction = UIAlertAction(title: "갤러리에서 선택", style: .default) { action in
            self.presentImagePicker()
            self.profileSetView.showSkeleton()
        }
        
        actionSheet.addAction(chooseImageAction)
        
        let deleteProfileAction = UIAlertAction(title: "사진 삭제하기", style: .destructive) { action in
            self.profileSetView.showSkeleton()
            self.deleteImage()
        }
        
        actionSheet.addAction(deleteProfileAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
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
    
    private func deleteImage() {
        let isDefaultImage = profileSetView.profileImageView.image != TNImage.userIcon
        
        if isDefaultImage {
            self.profileSetView.profileImageView.load(url: nil, defaultImage: TNImage.userIcon)
            imageDidChanged.onNext(()) 
            imageDidDeleted.onNext(true)
        }
    }
}

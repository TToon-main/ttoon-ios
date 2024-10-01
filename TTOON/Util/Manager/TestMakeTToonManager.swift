////
////  TestMakeTToonManager.swift
////  TTOON
////
////  Created by 임승섭 on 10/1/24.
////
//
// import Moya
// import RxSwift
// import UIKit
//
// class TestMakeTToonManager {
//    static let shared = TestMakeTToonManager()
//    private init() { }
//    
//    let provider = APIProvider<TestMakeTToonAPI>()
//    
//    func makeSampleTToon() -> Single<Result<Bool, Error>> {
//        return Single<Result<Bool, Error>>.create { single in
//            let request = self.provider.log.request(.makeTToon) { result in
//                print(result)
//            }
//            
//            return Disposables.create()
//        }
//    }
// }
//
// enum TestMakeTToonAPI {
//    case makeTToon
// }
//
// extension TestMakeTToonAPI: TargetType {
//    var baseURL: URL {
//        return URL(string: "https://ttoon.site")!
//    }
//    
//    var path: String {
//        switch self {
//        default:
//            return "/api/test/toon"
//        }
//    }
//    
//    var method: Moya.Method {
//        switch self {
//        default:
//            return .post
//        }
//    }
//    
//    var task: Moya.Task {
//        switch self {
//        default:
//            var multipartData: [MultipartFormData] = []
//            
//            let imageArr = [UIImage(named: "sample1"), UIImage(named: "sample2"), UIImage(named: "sample3"), UIImage(named: "sample4")]
//            
//            // 이미지 데이터를 multipart로 추가
//            for (index, image) in imageArr.enumerated() {
//                if let imageData = image?.jpegData(compressionQuality: 0.1) {
//                    let formData = MultipartFormData(provider: .data(imageData), name: "files", fileName: "image\(index + 1).jpg", mimeType: "image/jpeg")
//                    multipartData.append(formData)
//                }
//            }
//            
//            multipartData.append(MultipartFormData(provider: .data("샘플 데이터 제목제목".data(using: .utf8)!), name: "title"))
//            multipartData.append(MultipartFormData(provider: .data("샘플 데이터 내용내용내용내용내용내용내용내용내용내용내용내용".data(using: .utf8)!), name: "content"))
//            multipartData.append(MultipartFormData(provider: .data("\(Date().toString(of: .fullWithHyphen))".data(using: .utf8)!), name: "date"))
//            
//            return .uploadMultipart(multipartData)
//        }
//    }
//    
//    var headers: [String: String]? {
//        switch self {
//        default:
//            let token = KeychainStorage.shared.accessToken ?? ""
//            return [
//                "Content-Type": "multipart/form-data",
//                "Authorization": "Bearer \(token)"
//            ]
//        }
//    }
//    
//    var validationType: ValidationType {
//        return .successCodes
//    }
// }

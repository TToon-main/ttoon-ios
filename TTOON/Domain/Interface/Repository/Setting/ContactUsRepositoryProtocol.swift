//
//  ContactUsRepositoryProtocol.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol ContactUsRepositoryProtocol {
    func contactUsRequest(_ requestModel: ContactUsRequestModel) -> Single<Result<Bool, Error>>
}

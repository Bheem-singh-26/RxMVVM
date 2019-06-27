//
//  IssuesViewModel.swift
//  RxMVVM
//
//  Created by Bheem Singh on 27/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class IssuesViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let issues : PublishSubject<[Issue]> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    
    public func requestData(){
        
        
        APIManager.requestData(url: Constants.firebase_sdk_issues, method: .get, parameters: nil, completion: { (result) in
            
            switch result {
            case .success(let responseJson) :
                
                
                var issues = responseJson.arrayValue.compactMap{ return Issue(data: try!$0.rawData())}
                issues = issues.sorted(by: {$0.updated_at > $1.updated_at})
                self.issues.onNext(issues)
                
                
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError(StringConstants.checkInternet))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage(StringConstants.unknownError))
                }
                
            }
        })
        
    }
}


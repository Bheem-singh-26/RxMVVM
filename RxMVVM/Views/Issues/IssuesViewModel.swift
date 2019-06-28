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
import RealmSwift


class IssuesViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let issues : PublishSubject<[RealmIssue]> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    
    public func requestData(){
        
        // no date present in DB or data in DB is older than 24 hours
        if RealmManager.isDBEmplty() || RealmManager.isDBOlderThan24Hours(){
            fetchDataFromServer()
        }else{
            // if date present in DB
            self.issues.onNext(RealmManager.fetchIsseus())
        }
        
    }
    
    public func fetchDataFromServer(){
        
        APIManager.requestData(url: Constants.firebase_sdk_issues, method: .get, parameters: nil, completion: { (result) in
            
            switch result {
            case .success(let responseJson) :
                
                
                var issues = responseJson.arrayValue.compactMap{ return Issue(data: try!$0.rawData())}
                
                // Ordering issues list by recent updated
                issues = issues.sorted(by: {$0.updated_at > $1.updated_at})
                
                // Store issues to DB
                RealmIssue.save(issues: issues)
                RealmManager.saveDateDBWriteDate()
                
                let realmIssues = RealmIssue.mapRealmIssuesFrom(issues: issues)
                self.issues.onNext(realmIssues)
                
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


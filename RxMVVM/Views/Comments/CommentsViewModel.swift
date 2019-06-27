//
//  CommentsViewModel.swift
//  RxMVVM
//
//  Created by Bheem Singh on 27/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class CommnetsViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
        case empltyData(String)
    }
    
    public let comments : PublishSubject<[Comment]> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    public var comments_url:String!
    
    public func requestData(){
        
        
        APIManager.requestData(url: comments_url, method: .get, parameters: nil, completion: { (result) in
            
            switch result {
            case .success(let responseJson) :
                
                
                let comments = responseJson.arrayValue.compactMap{ return Comment(data: try!$0.rawData())}
                if comments.count > 0{
                     self.comments.onNext(comments)
                }else{
                    self.error.onNext(.empltyData("There is no comments avaiable for this issue"))
                }
               
                
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
                
            }
        })
        
    }
}



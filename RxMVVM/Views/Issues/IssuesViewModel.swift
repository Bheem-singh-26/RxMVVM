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
    
    public let events : PublishSubject<[Event]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    
    public func requestData(queryString:String){
        
        
        self.loading.onNext(true)
        let escapedString = queryString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        APIManager.requestData(url: "?client_id=MTY4MTM2NDN8MTU1OTEzMjU1Ny4y&q=\(escapedString)", method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let responseJson) :
                
                
                
                let events = responseJson["events"].arrayValue.compactMap{ return Event(data: try!$0.rawData())}
                self.events.onNext(events)
                
                
            //                self.tracks.onNext(tracks)
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


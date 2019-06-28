//
//  RealmManager.swift
//  RxMVVM
//
//  Created by Bheem Singh on 28/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager{
    
    static let lastDBWriteKey = "LastDBWriteDate"
    
    // To check issues are stroed in DB
    class func isDBEmplty() -> Bool{
        let realm = try! Realm()
        let issues = realm.objects(RealmIssue.self)
        if issues.count > 0 {
            return false
        }else{
            return true
        }
    }

    class func fetchIsseus() -> [RealmIssue]{
        var issuesResult = [RealmIssue]()
        let realm = try! Realm()
        let issues = realm.objects(RealmIssue.self)
        for issue in issues{
            issuesResult.append(issue)
        }
        return issuesResult
    }
    
    class func saveDateDBWriteDate(){
        UserDefaults.standard.set(Date(), forKey: RealmManager.lastDBWriteKey)
    }
    
    class func isDBOlderThan24Hours() -> Bool{
        print(UserDefaults.standard.object(forKey: RealmManager.lastDBWriteKey))
        if let prevDate = UserDefaults.standard.object(forKey: RealmManager.lastDBWriteKey) as? Date{
            let hours = Date().hours(from: prevDate)
            if hours > 24 {
                return true
            }
        }
        return false
    }
    
}

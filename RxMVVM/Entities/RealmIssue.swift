//
//  RealmIssue.swift
//  RxMVVM
//
//  Created by Bheem Singh on 28/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation
import RealmSwift


class RealmIssue: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var descriptionBody = ""
    @objc dynamic var updated_at = ""
    @objc dynamic var comments_url = ""
    @objc dynamic var id = 0
    @objc dynamic var number = 0

    
    class func save(issues: [Issue]){
        
        let realmIssues = self.mapRealmIssuesFrom(issues: issues)
        
        let realm = try! Realm()
        do {
            try! realm.write {
                realm.add(realmIssues)
            }
        }catch{
            // handle error
            print("issue is not saved in database")
        }
        
    }
    
    class func save(issue: Issue){
        let realmIssue = RealmIssue()
        realmIssue.id = issue.id
        realmIssue.number = issue.number
        realmIssue.title = issue.title
        realmIssue.descriptionBody = issue.description
        realmIssue.updated_at = issue.updated_at
        realmIssue.comments_url = issue.comments_url
        let realm = try! Realm()
        do {
            try! realm.write {
                realm.add(realmIssue)
            }
        }catch{
            // handle error
            print("issue is not saved in database")
        }
    }
    
    class func mapRealmIssuesFrom(issues:[Issue]) -> [RealmIssue]{
        var realmIssues = [RealmIssue]()
        for issue in issues{
            let realmIssue = RealmIssue()
            realmIssue.id = issue.id
            realmIssue.number = issue.number
            realmIssue.title = issue.title
            realmIssue.descriptionBody = issue.description
            realmIssue.updated_at = issue.updated_at
            realmIssue.comments_url = issue.comments_url
            
            realmIssues.append(realmIssue)
        }
        return realmIssues
    }
    
}

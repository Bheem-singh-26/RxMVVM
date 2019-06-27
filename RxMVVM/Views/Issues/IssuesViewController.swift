//
//  IssuesViewController.swift
//  RxMVVM
//
//  Created by Bheem Singh on 27/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IssuesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    public var issues = PublishSubject<[Issue]>()
    
    
    private let disposeBag = DisposeBag()
    public var issuesViewModel = IssuesViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpViewModel()
        setupBinding()
        issuesViewModel.requestData()
    }
    
    func setUpView(){
        
        self.title = "Issues"
        
    }
    
    private func setUpViewModel() {
        
        // observing errors to show
        
        issuesViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    self.alertWithMessage(title: "Feching data failed", message: message, handler: {
                        let _ = self.navigationController?.popViewController(animated: true)
                    })
                case .serverMessage(let message):
                    self.alertWithMessage(title: "Feching data failed", message: message, handler: {
                        let _ = self.navigationController?.popViewController(animated: true)
                    })
                }
            })
            .disposed(by: disposeBag)
        
        
        // binding albums to album container
        
        issuesViewModel
            .issues
            .observeOn(MainScheduler.instance)
            .bind(to: self.issues)
            .disposed(by: disposeBag)
        
        // binding tracks to track container
        
        
        
    }
    
    
    
    private func setupBinding(){
        
        tableView.register(UINib(nibName: "IssueTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: IssueTableViewCell.self))
        
        
        issues.bind(to: tableView.rx.items(cellIdentifier:"IssueTableViewCell", cellType: IssueTableViewCell.self)){
            (row ,issues,cell) in
            
            cell.cellIssue = issues
            
            }.disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                
                 let cell = self?.tableView.cellForRow(at: indexPath) as? IssueTableViewCell
                
                // Pushing to event detail
                let commentsVC = self?.storyboard?.instantiateViewController(withIdentifier: StoryboardId.comments) as? CommentsViewController
                commentsVC?.commnetsViewModel.comments_url = cell?.cellIssue.comments_url
                
                self?.navigationController?.pushViewController(commentsVC!, animated: true)
                
            }).addDisposableTo(disposeBag)
        
    }
    
    
}

//
//  CommentsViewController.swift
//  RxMVVM
//
//  Created by Bheem Singh on 27/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    public var comments = PublishSubject<[Comment]>()
    
    
    private let disposeBag = DisposeBag()
    public var commnetsViewModel = CommnetsViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpViewModel()
        setupBinding()
        commnetsViewModel.requestData()
    }
    
    func setUpView(){
        
        self.title = StringConstants.commentsViewTitle
        self.tableView.tableFooterView = UIView()
        
    }
    
    private func setUpViewModel() {
        
        // observing errors to show
        
        commnetsViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                    case .internetError(let message):
                        self.alertWithMessage(title: StringConstants.fetchDataFailed, message: message, handler: {
                            let _ = self.navigationController?.popViewController(animated: true)
                        })
                    case .serverMessage(let message):
                        self.alertWithMessage(title: StringConstants.fetchDataFailed, message: message, handler: {
                            let _ = self.navigationController?.popViewController(animated: true)
                        })
                    case .empltyData(let message):
                        self.alertWithMessage(title: StringConstants.noComment, message: message, handler: {
                            let _ = self.navigationController?.popViewController(animated: true)
                        })
                }
            })
            .disposed(by: disposeBag)
        
        
        // binding ViewModel comments to view comments container
        
        commnetsViewModel
            .comments
            .observeOn(MainScheduler.instance)
            .bind(to: self.comments)
            .disposed(by: disposeBag)
   
        
    }
    
    
    
    private func setupBinding(){
        
        
        tableView.register(UINib(nibName: CommnetTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CommnetTableViewCell.identifier)
        
        // binding comments to tableview
        
        comments.bind(to: tableView.rx.items(cellIdentifier:CommnetTableViewCell.identifier, cellType: CommnetTableViewCell.self)){
            (row ,comments,cell) in
            
            cell.cellComment = comments
            
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
        
        
    }
    
    
}


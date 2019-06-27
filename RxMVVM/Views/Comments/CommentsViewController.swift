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
        
        self.title = "Comments"
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
        
        commnetsViewModel
            .comments
            .observeOn(MainScheduler.instance)
            .bind(to: self.comments)
            .disposed(by: disposeBag)
        
        // binding tracks to track container
        
        
        
    }
    
    
    
    private func setupBinding(){
        
        
        tableView.register(UINib(nibName: "CommnetTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: CommnetTableViewCell.self))
        
        
        comments.bind(to: tableView.rx.items(cellIdentifier:"CommnetTableViewCell", cellType: CommnetTableViewCell.self)){
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
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                
                // Pushing to event detail
                let detailVC = self?.storyboard?.instantiateViewController(withIdentifier: StoryboardId.comments) as? CommentsViewController
                //detailVC?.eventDetails = cell?.cellevent
                
                self?.navigationController?.pushViewController(detailVC!, animated: true)
                
            }).addDisposableTo(disposeBag)
        
    }
    
    
}


//
//  UIViewControllerExt.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/25/23.
//

import Foundation
import UIKit
import SafariServices

extension UIViewController{  
    
    func presentGRAlert(title: String, message: String){
        
        //async doesnt need to run code on main thread, so dont need to dispatchqueue.async.main for this code
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default){action in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func presentDefaultError(){
        
        let alertController = UIAlertController(title: "Something went wrong", message: "We were unable to complete your task, please try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default){action in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    
    func add(_ childController: UIViewController, containerView: UIView) {
        addChild(childController)
        containerView.addSubview(childController.view)
        childController.view.frame = containerView.bounds
        childController.didMove(toParent: self)
    }
    
    func showEmptyStateView(with msg: String, img: UIImage, in view: UIView){
        let emptyStateView = GREmptyStateView(message: msg, img: img)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func presentSafariVC(with url: URL){
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}



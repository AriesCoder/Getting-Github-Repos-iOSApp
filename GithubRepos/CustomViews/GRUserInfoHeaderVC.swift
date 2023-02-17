//
//  GRUserInfoHeaderVC.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/24/23.
//

import UIKit
import SafariServices

class GRUserInfoHeaderVC: UIViewController {
    
    let avtImgView      = GRAvtImgView(frame: .zero)
    let usernameLabel   = GRTitleLabel(textAlighment: .left, fontSize: 34)
    let fullnameLabel   = GRSecondaryTitleLabel(fontSize: 20)
    let fullnameImgView = UIImageView()
    let gitURL          = GRSecondaryTitleLabel(fontSize: 20)
    let gitURLImgView   = UIImageView()
    let emailLabel      = GRSecondaryTitleLabel(fontSize: 20)
    let emailImgView    = UIImageView()
    let twitterLabel    = GRSecondaryTitleLabel(fontSize: 20)
    let twitterImgView  = UIImageView()
    let location        = GRSecondaryTitleLabel(fontSize: 20)
    let locationImgView = UIImageView()
    
    var user: User!
    
    init(user: User){
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIs()
    }
    
    
    func configureUIs(){
        
        view.addSubview(avtImgView)
        view.addSubview(usernameLabel)
        view.addSubview(gitURLImgView)
        view.addSubview(gitURL)
        view.addSubview(fullnameImgView)
        view.addSubview(fullnameLabel)
        view.addSubview(emailImgView)
        view.addSubview(emailLabel)
        view.addSubview(twitterImgView)
        view.addSubview(twitterLabel)
        view.addSubview(locationImgView)
        view.addSubview(location)
        
        layoutUI()
        
        avtImgView.backgroundColor = .systemBlue
        avtImgView.downloadImg(fromURL: user.avatarUrl)
        
        usernameLabel.text          = user.login
        
        fullnameImgView.image       = Images.fullnameImg
        fullnameImgView.tintColor   = .black
        fullnameLabel.text          = user.name ?? "No name added"
        
        gitURLImgView.image         = Images.gitURLImg
        hyperlinkLabel(label: gitURL, url: user.htmlUrl, string: "Github Profile")
        
        emailImgView.image          = Images.emailImg
        emailImgView.tintColor      = .black
        emailLabel.text             = user.email ?? "No email added"
        
        twitterImgView.image        = Images.twittetImg
        twitterLabel.text           = user.twitterUsername ?? "No Twitter username added"
        
        locationImgView.image       = Images.locationImg
        locationImgView.tintColor   = .black
        location.text               = user.location ?? "No location added"
    }
    
    func hyperlinkLabel(label: UILabel, url: String, string: String){
        label.attributedText =
        NSMutableAttributedString(string: string, attributes:[NSAttributedString.Key.link: URL(string: url)!])
        label.isUserInteractionEnabled = true
        
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        label.addGestureRecognizer(guestureRecognizer)
    }
    
    @objc func labelTapped(){
            let safariVC = SFSafariViewController(url: URL(string: user.htmlUrl)!)
            safariVC.preferredControlTintColor = .systemGreen
            present(safariVC, animated: true)
     
    }
    
    func layoutUI(){
        
        let padding: CGFloat        = 20
        let textImgPadding: CGFloat = 12
        
        gitURLImgView.translatesAutoresizingMaskIntoConstraints = false
        fullnameImgView.translatesAutoresizingMaskIntoConstraints = false
        emailImgView.translatesAutoresizingMaskIntoConstraints = false
        twitterImgView.translatesAutoresizingMaskIntoConstraints = false
        locationImgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avtImgView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avtImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avtImgView.heightAnchor.constraint(equalToConstant: 90),
            avtImgView.widthAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.topAnchor.constraint(equalTo: avtImgView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avtImgView.trailingAnchor, constant: textImgPadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            gitURLImgView.centerYAnchor.constraint(equalTo: avtImgView.centerYAnchor, constant: 8),
            gitURLImgView.leadingAnchor.constraint(equalTo: avtImgView.trailingAnchor, constant: textImgPadding),
            gitURLImgView.widthAnchor.constraint(equalToConstant: 20),
            gitURLImgView.heightAnchor.constraint(equalToConstant: 20),
            
            gitURL.centerYAnchor.constraint(equalTo: avtImgView.centerYAnchor, constant: 8),
            gitURL.leadingAnchor.constraint(equalTo: gitURLImgView.trailingAnchor, constant: textImgPadding),
            gitURL.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            gitURL.heightAnchor.constraint(equalToConstant: 22),
            
            fullnameImgView.bottomAnchor.constraint(equalTo: avtImgView.bottomAnchor),
            fullnameImgView.leadingAnchor.constraint(equalTo: avtImgView.trailingAnchor, constant: textImgPadding),
            fullnameImgView.widthAnchor.constraint(equalToConstant: 20),
            fullnameImgView.heightAnchor.constraint(equalToConstant: 20),
            
            fullnameLabel.bottomAnchor.constraint(equalTo: avtImgView.bottomAnchor),
            fullnameLabel.leadingAnchor.constraint(equalTo: fullnameImgView.trailingAnchor, constant: textImgPadding),
            fullnameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            fullnameLabel.heightAnchor.constraint(equalToConstant: 22),
          
            emailImgView.topAnchor.constraint(equalTo: avtImgView.bottomAnchor, constant: textImgPadding),
            emailImgView.leadingAnchor.constraint(equalTo: avtImgView.leadingAnchor),
            emailImgView.heightAnchor.constraint(equalToConstant: 20),
            emailImgView.widthAnchor.constraint(equalToConstant: 20),

            emailLabel.topAnchor.constraint(equalTo: emailImgView.topAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: emailImgView.trailingAnchor, constant: textImgPadding),
            emailLabel.heightAnchor.constraint(equalToConstant: 22),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            twitterImgView.topAnchor.constraint(equalTo: emailImgView.bottomAnchor, constant: textImgPadding),
            twitterImgView.leadingAnchor.constraint(equalTo: avtImgView.leadingAnchor),
            twitterImgView.heightAnchor.constraint(equalToConstant: 18),
            twitterImgView.widthAnchor.constraint(equalToConstant: 18),
            
            twitterLabel.topAnchor.constraint(equalTo: twitterImgView.topAnchor),
            twitterLabel.leadingAnchor.constraint(equalTo: twitterImgView.trailingAnchor, constant: textImgPadding),
            twitterLabel.heightAnchor.constraint(equalToConstant: 22),
            twitterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            locationImgView.topAnchor.constraint(equalTo: twitterImgView.bottomAnchor, constant: textImgPadding),
            locationImgView.leadingAnchor.constraint(equalTo: twitterImgView.leadingAnchor),
            locationImgView.heightAnchor.constraint(equalToConstant: 20),
            locationImgView.widthAnchor.constraint(equalToConstant: 20),
            
            location.topAnchor.constraint(equalTo: locationImgView.topAnchor),
            location.leadingAnchor.constraint(equalTo: locationImgView.trailingAnchor, constant: textImgPadding),
            location.heightAnchor.constraint(equalToConstant: 22),
            location.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
        ])
    }

}

//
//  String+LinkChecker.swift
//  Freetime
//
//  Created by B_Litwin on 10/11/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit
import SnapKit

private let gitHubRegex = try! NSRegularExpression(
    pattern: "https?:\\/\\/.*github.com",
    options: []
)

private let slashRegex = try! NSRegularExpression(
    pattern: "[^/]+",
    options: []
)


func githubURLParts(url urlString: String) -> [String]? {
    
    let githubURL = gitHubRegex.matches(
        in: urlString,
        options: [],
        range: urlString.nsrange
    )
    
    guard !githubURL.isEmpty else {
        return nil
    }
    
    let matches = slashRegex.matches(
        in: urlString,
        options: [],
        range: urlString.nsrange
        ) .map {
            urlString.substring(with: $0.range(at: 0))
    }
    
    let retMatches: [String] = matches.compactMap({$0})
    
    // being conservative for time being, i'm not sure what a null val would indicate here
    guard retMatches.count == matches.count else { return nil }
    
    let rMatches = retMatches.filter {
        $0 != "https:"
        && $0 != "github.com"
    }
    
    guard rMatches.isEmpty == false else { return nil }
    return rMatches
}



enum RouteFromURL {
    case issue(owner: String, repo: String, number: Int)
    case repository(owner: String, repository: String)
}


func routeInAppFromGitHubURL(url: String) -> RouteFromURL? {
    guard let urlParts = githubURLParts(url: url) else {
        return nil
    }
    
    switch urlParts.count {
    
    case 2:
        
        return .repository(
            owner: urlParts[0],
            repository: urlParts[1]
        )
        
        //return nil
        
    case 4:
        if urlParts[2].lowercased() == "issues",
            let number = Int(urlParts[3]) {
            return .issue(
                owner: urlParts[0],
                repo: urlParts[1],
                number: number
            )
        }
        
        return nil
        
    default:
        return nil
        
    }
    
}



extension UIViewController {
    
    func throwSpinnerOverlay(message: String) -> SpinnerView {
        let spOverlay = SpinnerView()
        view.addSubview(spOverlay)
        spOverlay.label.text = message 
        
        spOverlay.setup()
        
        spOverlay.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-view.frame.height * 0.1)
        }
        
        spOverlay.label.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(view.frame.width * 0.8)
        }
        
        return spOverlay
        //spOverlay.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
    }
    
    func routeTo(route: RouteFromURL) {
        switch route {
        case .repository(let owner, let repo):
            
            
            break
            
        case .issue(let owner, let repo, let number):
            break
            
        }
    }
}

protocol RoutesToRepository {
    var githubClient: GithubClient { get }
}

extension RoutesToRepository where Self: UIViewController {
    
    // are we creating retain cycles ??
    
    func showRepository(owner: String, repository: String) {
        let spinner = throwSpinnerOverlay(message: "Fetching \(repository)")
        
        let query = GetRepositoryDetailQuery(owner: owner, name: repository)
        
        githubClient.client.query(query, result: { $0.repository }) { result in
            switch result {
            case .success(let repo):
                let repositoryDetails = RepositoryDetails(
                    owner: owner,
                    name: repository,
                    defaultBranch: repo.defaultBranchRef?.name ?? "master",
                    hasIssuesEnabled: repo.hasIssuesEnabled
                )
                
                let vc = RepositoryViewController(
                    client: self.githubClient,
                    repo: repositoryDetails
                )
                self.show(vc, sender: self)
                
            case .failure(let error):
                print(error)
            }
            
            spinner.frame = .zero
        }
        
        
        //throwSpinnerOverlay(message: "Loading \(repository)")
    }
}


extension RepositoryOverviewViewController: RoutesToRepository { }






class SpinnerView: UIView {
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let label = UILabel()
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let nOfLines = label.calculateMaxLines()
//        label.snp.makeConstraints { make in
//            make.height.equalTo(16 * nOfLines)
//        }
//    }
    
    func setup() {
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        label.setContentCompressionResistancePriority(
            UILayoutPriority.defaultLow,
            for: .horizontal
        )
        
        layer.cornerRadius = 10.0
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        addSubview(label)
        
        spinner.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(20)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.leading.equalTo(self.snp.leading).offset(25)
            make.trailing.equalTo(self.snp.trailing).offset(-25)
            make.height.equalTo(16)
            make.top.equalTo(spinner.snp.bottom).offset(10)
        }
        
        
//        //configure spinner
//        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        spinner.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
//        spinner.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10).isActive = true
//
//        //configure label
//        label.textColor = .white
//        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
//        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
//        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 25).isActive = true

        label.textColor = UIColor.white
        spinner.startAnimating()
    }
    
}

extension UILabel {
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let lines = Int(textSize.height/charSize)
        return lines
    }
    
}


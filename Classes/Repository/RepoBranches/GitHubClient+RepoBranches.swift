//
//  GitHubClient+RepoBranches.swift
//  Freetime
//
//  Created by B_Litwin on 9/25/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import GitHubAPI

extension GithubClient {
    
    func fetchRepoBranches(owner: String,
                           repo: String,
                           currentBranch: String,
                           completion: @escaping (Result<RepoBranches>)->Void
    ) {
        let query = FetchRepositoryBranchesQuery(owner: owner, name: repo)
        client.query(query, result: { $0.repository }) { result in
        
        switch result {
        case .failure(let error):
                completion(.error(error))
    
        case .success(let repository):
            var branches: [String] = []
            repository.refs.map { edges in
                edges.edges.map { edge in
                    branches += edge.compactMap {
                        $0?.node?.name
                    }
                }
            }
    
            let repoBranches = RepoBranches(branches: branches,
                                            currentBranch: currentBranch
            )
            completion(.success(repoBranches))
            }
        }
    }
}

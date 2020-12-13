//
//  ViewController.swift
//  Networking
//
//  Created by Djuro on 12/13/20.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager().fetchPosts { result in
            switch result {
            case .success(let posts):
                print("Posts: \(posts)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

}

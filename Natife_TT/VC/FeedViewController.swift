//
//  ViewController.swift
//  Natife_TT
//
//  Created by Jane Strashok on 25.10.2023.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var posts: [FeedPost.Post]?
    override func viewDidLoad() {
        super.viewDidLoad()
        configSortButton()
        configTable()
        fetchPosts()
        // Do any additional setup after loading the view.
    }
    
    private func configTable () {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func configSortButton() {
        let action = { (action: UIAction) in
            switch action.title {
            case "Likes":
                self.posts?.sort { $0.likesCount > $1.likesCount }
            case "Date":
                self.posts?.sort { $0.timeshamp > $1.timeshamp }
            default:
                break
            }
            self.tableView.reloadData()
        }
        
        sortButton.menu = UIMenu(children: [UIAction(title: "Likes", image: UIImage(systemName: "heart"),handler: action),
                                            UIAction(title: "Date", image: UIImage(systemName: "calendar"), handler: action)])
        
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
    }
    
    private func fetchPosts() {
        PostNetworkManager.shared.fetchFeed { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case let .success(posts):
                self.posts = posts.posts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .error(description):
                print(description)
            }
        }
    }
    
}

extension FeedViewController: UITableViewDelegate {
    
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPostTableViewCell") as? FeedPostTableViewCell else { return UITableViewCell() }
        
        
        return cell
    }
    
    
}


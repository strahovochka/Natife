//
//  PostViewController.swift
//  Natife_TT
//
//  Created by Jane Strashok on 25.10.2023.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var postId: Int? {
        didSet {
            fetchPost()
        }
    }
    var post: FullPost.Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
        // Do any additional setup after loading the view.
    }
    
    private func configTable() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func fetchPost() {
        if let postId = postId {
            PostNetworkManager.shared.fetchPostWith(id: postId ) { [weak self] response in
                guard let self = self else { return }
                
                switch response {
                case let .success(post):
                    self.post = post.post
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case let .error(description):
                    print(description)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostViewController: UITableViewDelegate {
    
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FullPostTableViewCell") as? FullPostTableViewCell, let post = post else { return UITableViewCell() }
        
        let dispatchQueue = DispatchQueue(label: "com.download.image")
        if let image = URL(string: post.postImage) {
            dispatchQueue.async {
                if let data = try? Data(contentsOf: image) {
                    DispatchQueue.main.async { [weak self] in
                        guard self != nil else { return }
                        cell.postImage.image = UIImage(data: data)
                    }
                }
            }
        }
        
        cell.postTitle.text = post.title
        cell.content.text = post.text
        cell.likesCount.text = String(post.likesCount)
        cell.date.text = TimeInterval(post.timeshamp).stringDate
        
        return cell
    }
    
    
}

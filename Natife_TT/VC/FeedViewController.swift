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
    private var expandedPosts = [Int]()
    
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
                self.posts?.sort { $0.timeshamp < $1.timeshamp }
            default:
                break
            }
            self.sortButton.setImage(action.image, for: .normal)
            self.tableView.reloadData()
        }
        
        sortButton.menu = UIMenu(children: [UIAction(title: "Likes", image: UIImage(systemName: "heart.rectangle.fill"),handler: action),
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
    
    //MARK: -Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let postVC = segue.destination as? PostViewController {
            if let post = posts?[tableView.indexPathForSelectedRow?.row ?? 0] {
                postVC.postId = post.postId
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
        
        guard let post = posts?[indexPath.row] as? FeedPost.Post else { return UITableViewCell() }
        tableView.beginUpdates()
        cell.postTitle.text = post.title
        cell.postText.text = post.previewText
        cell.likesCount.text = String(post.likesCount)
        
        let timeStamp = TimeInterval(post.timeshamp).stringDate
        cell.date.text = timeStamp
        
        cell.didExpandButtonPressed = {
            tableView.beginUpdates()
            if cell.postText.numberOfLines == 0 {
                self.expandedPosts.append(post.postId)
            } else {
                self.expandedPosts.removeAll { $0 == post.postId}
            }
            tableView.endUpdates()
        }
        tableView.endUpdates()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FeedPostTableViewCell {
            let lines = cell.postText.maxNumberOfLines
            tableView.beginUpdates()
            cell.expandButton.isHidden = true
            
            if let post = posts?[indexPath.row] {
                if expandedPosts.contains(post.postId) {
                    cell.postText.numberOfLines = 0
                    cell.expandButton.isHidden = false
                    cell.expandButton.setTitle("Collapse", for: .normal)
                } else if lines > 2 {
                    cell.postText.numberOfLines = 2
                    cell.expandButton.isHidden = false
                    cell.expandButton.setTitle("Expand", for: .normal)
                }
            }
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPostView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension UILabel {
    var maxNumberOfLines: Int {
        let size = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil).height
        let lineHeight = font.lineHeight
        return Int( ceil(textHeight/lineHeight) )
    }
}

extension TimeInterval {
    var stringDate: String {
        let date = Date.init(timeIntervalSinceNow: -self)
        let calendar = Calendar.current
        let componentSet: Set = [Calendar.Component.year, .month, .day, .hour, .minute, .second]
        let components = calendar.dateComponents(componentSet, from: date, to: Date())
        
        if let year = components.year, year > 5 {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: date)
        } else {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            if components.year != nil {
                formatter.allowedUnits = [.year]
            } else if  components.month != nil {
                formatter.allowedUnits = [.month]
            } else if  components.day != nil {
                formatter.allowedUnits = [.day]
            } else if  components.hour != nil {
                formatter.allowedUnits = [.hour]
            } else if  components.minute != nil {
                formatter.allowedUnits = [.minute]
            } else if  components.second != nil {
                formatter.allowedUnits = [.second]
            }
            
            return formatter.string(from: self) ?? ""
        }
    }
}


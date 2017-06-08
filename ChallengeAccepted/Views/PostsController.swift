import Foundation
import UIKit
import CoreData

class PostsController: UITableViewController {

    var postPresenter: PostPresenter?

    fileprivate var dataService: DataService
    fileprivate var fetchController: NSFetchedResultsController<Post>
    fileprivate let cellIdentifier = "Post"
    
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)


    init(dataService: DataService) {
        self.dataService = dataService
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(#keyPath(Post.title))", ascending: true)]
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataService.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init(style: .plain)
        fetchController.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("This initializer is not supported on PostsController")
    }

    override func viewDidLoad() {
        self.title = "Challenge Accepted!"
        tableView.register(PostCell.self, forCellReuseIdentifier: cellIdentifier)
        fetchController.safePerformFetch()

        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage() 
        tableView.tableHeaderView = searchBar
        tableView.backgroundColor = AppColor.purple
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        tableView.separatorStyle = .none
        clearsSelectionOnViewWillAppear = false;
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.selectNearestCell(indexPath: selectedIndexPath)
    }
}

// MARK: - UISearchBar delegate methods
extension PostsController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "") {
            fetchController.fetchRequest.predicate = nil
        } else {
            fetchController.fetchRequest.predicate = NSPredicate(format: "title CONTAINS \"\(searchText)\"", argumentArray: nil)
        }
        fetchController.safePerformFetch()
        tableView.reloadData()
    }
}

// MARK: - UITableView delegate methods
extension PostsController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostCell
        cell.post = fetchController.object(at: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if let postPresenter = postPresenter {
            let post = fetchController.object(at: indexPath)
            postPresenter.present(post: post);
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = fetchController.object(at: indexPath)
        return PostCell.height(forTitle: post.title!, tableView: tableView)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting post: \(fetchController.object(at: indexPath))")
            dataService.viewContext.delete(fetchController.object(at: indexPath))
            dataService.saveContext()
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension PostsController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if newIndexPath!.row <= selectedIndexPath.row {
                selectedIndexPath.row += 1
            }
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            if indexPath!.row < selectedIndexPath.row {
                selectedIndexPath.row -= 1
            }
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            if let postCell = tableView.cellForRow(at: indexPath!) as? PostCell {
                postCell.post = anObject as? Post
            }
        case .move:
            if let postCell = tableView.cellForRow(at: indexPath!) as? PostCell {
                postCell.post = anObject as? Post
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            }
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        tableView.selectNearestCell(indexPath: selectedIndexPath)
    }
    
    
}

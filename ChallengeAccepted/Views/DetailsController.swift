
import Foundation
import UIKit
import CoreData

class DetailsController: UIViewController, PostPresenter {

    var titleLabel = UILabel()
    var bodyLabel = UILabel()
    var albumCollectionView: UICollectionView?
    
    fileprivate var fetchController: NSFetchedResultsController<Photo>
    fileprivate var dataService: DataService
    fileprivate var collapseState = Dictionary<Int, Bool>()

    init(dataService: DataService) {
        self.dataService = dataService
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "\(#keyPath(Photo.title))", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataService.viewContext, sectionNameKeyPath: "\(#keyPath(Photo.albumId))", cacheName: "Photos")
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This initializer has not been implemented")
    }

    override func viewDidLoad() {
        edgesForExtendedLayout = UIRectEdge()
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = AppColor.purple
        createSubviews()
    }

    func present(post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
        
        NSFetchedResultsController<Photo>.deleteCache(withName: "Photos")
        let predicate = NSPredicate(format: "album.userId == \(post.userId)")
        fetchController.fetchRequest.predicate = predicate
        let sort = NSSortDescriptor(key: "\(#keyPath(Photo.albumId))", ascending: true)
        fetchController.fetchRequest.sortDescriptors = [sort]
        fetchController.delegate = self
        fetchController.safePerformFetch()
        albumCollectionView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        resetSectionState()
    
    }

    private func createSubviews() {
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: UIFontWeightThin)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-20)
        }

        bodyLabel.textColor = UIColor.white
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .byWordWrapping
        view.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.headerReferenceSize = CGSize(width: 200, height: 50)
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "Photo")
        collectionView.register(AlbumHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.backgroundColor = AppColor.purple
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(60)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        albumCollectionView = collectionView
    }
    
    fileprivate func resetSectionState() {
        if let sectionCount = fetchController.sections?.count {
            collapseState = Dictionary<Int, Bool>(minimumCapacity: sectionCount)
            for index in 0..<sectionCount {
                collapseState[index] = true
            }
        }
        albumCollectionView?.reloadData()
    }
    
    fileprivate func collapseSection(section: Int) -> Bool {
        self.collapseState[section] = !self.collapseState[section]!
        albumCollectionView?.performBatchUpdates({
            let indexPaths = (0..<self.fetchController.sections![section].numberOfObjects).map({ index in IndexPath(row: index, section: section) })
            if self.collapseState[section]! {
                self.albumCollectionView?.deleteItems(at: indexPaths)
            } else {
                self.albumCollectionView?.insertItems(at: indexPaths)
            }
        }, completion: nil)
        return self.collapseState[section]!
    }
}

// MARK: - UICollectionViewDataSource methods
extension DetailsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collapsed = collapseState[section] {
            if collapsed {
                return 0
            }
        }
        return fetchController.sections![section].numberOfObjects
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCell
        photoCell.photo = fetchController.object(at: indexPath)
        return photoCell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchController.sections?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! AlbumHeader
        header.label.text = (fetchController.sections![indexPath.section].objects!.first as! Photo).album!.title
        header.backgroundShape.backgroundColor = indexPath.section % 2 == 0 ? AppColor.pink : AppColor.lightPurple
        header.onCollapseDelegate = { return self.collapseSection(section: indexPath.section) }
        return header
    }
}

extension DetailsController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        resetSectionState()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        resetSectionState()
    }
}

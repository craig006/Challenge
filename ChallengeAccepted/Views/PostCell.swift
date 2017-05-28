
import Foundation
import UIKit
import SnapKit

class PostCell: UITableViewCell {

    var title = UILabel()
    var email = UILabel()
    static let titleFont = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)

    var post: Post? {
        didSet {
            title.text = post?.title
            email.text = post?.user?.email
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }

    private func createSubviews() {
        title.font = PostCell.titleFont
        title.textColor = UIColor.black
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
        }

        email.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        email.textColor = UIColor(red: 0.909, green: 0.094, blue: 0.407, alpha: 1)//UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        addSubview(email)
        email.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-15)
        }
    }

    static func height(forTitle title: String, tableView: UITableView) -> CGFloat{
        let constraintRect = CGSize(width: tableView.frame.width - 40, height: .greatestFiniteMagnitude)
        let boundingBox = title.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: PostCell.titleFont], context: nil)
        return boundingBox.height + 55
    }
}

import Foundation
import UIKit

class AlbumHeader: UICollectionReusableView {
    
    typealias OnCollapseDelegate = () -> (Bool)
    
    var label = UILabel()
    var button = UIButton()
    var onCollapseDelegate: OnCollapseDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }

    private func createSubviews() {
        
        backgroundColor = UIColor(red:0.34, green:0.79, blue:0.87, alpha:1.0)
        
        button.addTarget(self, action: #selector(collapseTouchUpInside), for: .touchUpInside)
        button.setTitle("Show", for: .normal)
        button.setTitleColor(UIColor(red:0.34, green:0.79, blue:0.87, alpha:1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: 0.1)
        button.contentHorizontalAlignment = .right
        addSubview(button)
        button.snp.makeConstraints { make -> Void in
            make.height.equalTo(self)
            make.right.equalTo(self).offset(-25)
            make.width.equalTo(100)
        }

        label.textColor = UIColor(red: 0.909, green: 0.094, blue: 0.407, alpha: 1)
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: 0.1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        addSubview(label)
        label.snp.makeConstraints { make -> Void in
            make.height.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(button.snp.left)
        }
        
    }
    
    @objc private func collapseTouchUpInside() {
        if let onCollapseDelegate = onCollapseDelegate {
            let collapsed = onCollapseDelegate()
            button.setTitle(collapsed ? "Show" : "Hide", for: .normal)
        }
    }
}

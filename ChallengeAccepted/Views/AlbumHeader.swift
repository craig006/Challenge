import Foundation
import UIKit

class AlbumHeader: UICollectionReusableView {
    
    typealias OnCollapseDelegate = () -> (Bool)
    
    var label = UILabel()
    var button = UIButton()
    var backgroundShape = UIView()
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
        
        backgroundColor = UIColor.clear
        backgroundShape.layer.cornerRadius = 25
        backgroundShape.layer.masksToBounds = true
        backgroundShape.backgroundColor = AppColor.pink
        addSubview(backgroundShape)
        backgroundShape.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.right.equalToSuperview().offset(-30)
        }
        
        button.addTarget(self, action: #selector(collapseTouchUpInside), for: .touchUpInside)
        button.setTitle("Show", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFontWeightThin)
        backgroundShape.addSubview(button)
        button.snp.makeConstraints { make -> Void in
            make.size.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }

        label.textColor = UIColor.white
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        addSubview(label)
        label.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview()
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

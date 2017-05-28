import Foundation
import UIKit

class AlbumHeader: UICollectionReusableView {
    var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }

    private func createSubviews() {
        backgroundColor = UIColor.white
        label.textColor = UIColor(red: 0.909, green: 0.094, blue: 0.407, alpha: 1)
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: 0.1)
        addSubview(label)
        label.snp.makeConstraints { make -> Void in
            make.size.equalTo(self)
            make.left.equalTo(self).offset(20)
        }
    }
}

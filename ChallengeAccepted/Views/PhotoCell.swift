import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {

    var imageView = UIImageView()
    var remoteImage = RemoteImage()

    var photo: Photo?{
        didSet {
            imageView.image = nil
            if let photo = photo, let thumbnailUrl = photo.thumbnailUrl, let url = URL(string: thumbnailUrl) {
                remoteImage.fetch(url: url, imageCallBack: self.animateToNewImage)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }

    private func createSubviews() {
        imageView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make -> Void in
            make.size.equalTo(self)
        }
    }

    private func animateToNewImage(image: UIImage?) {
        UIView.transition(with: self.imageView, duration: 0.3, options: .transitionCrossDissolve,
                animations: {
                    self.imageView.image = image
                },
                completion: nil)
    }
}
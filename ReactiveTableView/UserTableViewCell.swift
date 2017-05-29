import UIKit
import AlamofireImage

class UserTableViewCell: UITableViewCell {
	
	static var cellId: String {
		return "UserCell"
	}

	@IBOutlet weak var userImageView: UIImageView! {
		didSet {
			userImageView.layer.masksToBounds = true
			userImageView.layer.cornerRadius = userImageView.frame.size.width / 2.0
			userImageView.layer.borderColor = UIColor.darkGray.cgColor
			userImageView.layer.borderWidth = 1.0
		}
	}
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	override func prepareForReuse() {
		userImageView.image = nil
		nameLabel.text = ""
		phoneLabel.text = ""
		emailLabel.text = ""
	}
	
	func configure(with userViewModel: UserCellViewModel) {
		nameLabel.text = userViewModel.name
		emailLabel.text = userViewModel.email
		phoneLabel.text = userViewModel.phone
		if let imageUrl = userViewModel.imageURL {
			userImageView.af_setImage(withURL: imageUrl)
		}
	}
}

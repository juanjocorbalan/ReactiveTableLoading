import Foundation
import UIKit

class UserCellViewModel {
	
	let user: User
	
	var name: String = ""
	var email: String = ""
	var phone: String = ""
	var imageURL: URL? = nil
	
	init(user: User) {
		self.user = user
		
		self.name = (user.name + " " + user.surname).capitalized
		self.phone = user.phone
		self.email = user.email
		self.imageURL = URL(string: user.image)
	}
}

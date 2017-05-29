import Foundation

struct User: JSONDecodable {
	
	var identifier: String = ""
	var name: String = ""
	var surname: String = ""
	var email: String = ""
	var phone: String = ""
	var image: String = ""
	
	init(identifier: String, name: String, surname: String, email: String, phone: String, image: String) {
		self.identifier = identifier
		self.name = name
		self.surname = surname
		self.email = email
		self.phone = phone
		self.image = image
	}
	
	init() {
		self.init(identifier: "placeholder", name: "placeholder", surname: "placeholder", email: "placeholder", phone: "placeholder", image: "placeholder")
	}
	
	init?(dictionary: JSONDictionary) {
		guard let identifier = (dictionary["login"] as! JSONDictionary)["md5"] as? String else { return nil }
		guard let name = (dictionary["name"] as! JSONDictionary)["first"] as? String else { return nil }
		guard let surname = (dictionary["name"] as! JSONDictionary)["last"] as? String else { return nil }
		guard let email = dictionary["email"] as? String else { return nil }
		guard let phone = dictionary["cell"] as? String else { return nil }
		guard let image = (dictionary["picture"] as! JSONDictionary)["medium"] as? String else { return nil }
		
		self.init(identifier: identifier, name: name, surname: surname, email: email, phone: phone, image: image)
	}
}

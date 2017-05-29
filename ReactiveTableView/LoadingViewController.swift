import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {
	
	@IBOutlet weak var loadingView: NVActivityIndicatorView! {
		didSet {
			loadingView.type = .triangleSkewSpin
			loadingView.color = UIColor.red
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadingView.startAnimating()
	}
	
	public func setupConstraints() {
		
		let viewLeadingConstraint = NSLayoutConstraint(item:self.view,
		                                               attribute:.leading,
		                                               relatedBy:.equal,
		                                               toItem:self.view.superview,
		                                               attribute:.leading,
		                                               multiplier:1.0,
		                                               constant:0)
		
		let viewTrailingConstraint = NSLayoutConstraint(item:self.view,
		                                                attribute:.trailing,
		                                                relatedBy:.equal,
		                                                toItem:self.view.superview,
		                                                attribute:.trailing,
		                                                multiplier:1.0,
		                                                constant:0)
		
		let viewTopConstraint = NSLayoutConstraint(item:self.view,
		                                           attribute:.top,
		                                           relatedBy:.equal,
		                                           toItem:self.view.superview,
		                                           attribute:.top,
		                                           multiplier:1.0,
		                                           constant:0)
		
		let viewBottomConstraint = NSLayoutConstraint(item:self.view,
		                                              attribute:.bottom,
		                                              relatedBy:.equal,
		                                              toItem:self.view.superview,
		                                              attribute:.bottom,
		                                              multiplier:1.0,
		                                              constant:0)
		
		self.view.superview?.addConstraints([viewLeadingConstraint, viewTrailingConstraint, viewTopConstraint, viewBottomConstraint])
		
		self.view.superview?.layoutIfNeeded()
	}
}

import UIKit

extension UIColor {
    
    static func backgroundFadedGrey()->UIColor {
        return UIColor(red: (246.0/255.0), green: (247.0/255.0), blue: (248.0/255.0), alpha: 1)
    }
    
    static func gradientFirstStop()->UIColor {
        return  UIColor(red: (238.0/255.0), green: (238.0/255.0), blue: (238.0/255.0), alpha: 1.0)
    }
    
    static func gradientSecondStop()->UIColor {
        return UIColor(red: (221.0/255.0), green: (221.0/255.0), blue:(221.0/255.0) , alpha: 1.0);
    }
}

public class Shimmer {
	
    public static func addShimmerTo(_ view: UIView) {
		DispatchQueue.main.async {
			CATransaction.begin()
			view.addLoader()
			CATransaction.commit()
		}
    }
	
    public static func removeShimmerFrom(_ view: UIView) {
		DispatchQueue.main.async {
			CATransaction.begin()
			view.removeLoader()
			CATransaction.commit()
		}
    }
}

class ShimmmerView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.frame = frame
		self.backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.fill(self.bounds)
        
        for view in (self.superview?.subviews)! where view != self {
			cutoutSubviewsOfView(view: view, in: context, origin: self)
        }
    }

	func cutoutSubviewsOfView(view: UIView, in context: CGContext, origin: UIView) {
		let subviews = view.subviews
		
		if subviews.count == 0 {
			return
		}
		
		for subview in subviews {
			if subview is UILabel || subview is UIImageView {
				context.setBlendMode(.clear);
				context.setFillColor(UIColor.clear.cgColor)
				context.fill(view.convert(subview.frame, to: origin))
			} else {
				cutoutSubviewsOfView(view: subview as UIView, in: context, origin: origin)
			}
		}
	}
}

var cutoutHandle: UInt8 = 0
var gradientHandle: UInt8 = 0

extension UIView {
	
    public func getCutoutView()->UIView? {
        return objc_getAssociatedObject(self, &cutoutHandle) as! UIView?
    }
    
    func setCutoutView(aView : UIView) {
        return objc_setAssociatedObject(self, &cutoutHandle, aView, .OBJC_ASSOCIATION_RETAIN)
    }
    
    func getGradient()->CAGradientLayer? {
        return objc_getAssociatedObject(self, &gradientHandle) as! CAGradientLayer?
    }
    
    func setGradient(aLayer : CAGradientLayer) {
        return objc_setAssociatedObject(self, &gradientHandle, aLayer, .OBJC_ASSOCIATION_RETAIN)
    }
    
    public func addLoader() {
        let gradient: CAGradientLayer = CAGradientLayer()
		gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        
        self.configureAndAddAnimationToGradient(gradient: gradient)
        self.addShimmerView()
    }
    
    public func removeLoader() {
        self.getCutoutView()?.removeFromSuperview()
        self.getGradient()?.removeAllAnimations()
        self.getGradient()?.removeFromSuperlayer()
        
        for view in self.subviews {
			UIView.animate(withDuration: 0.5, animations: {
				view.alpha = 1
			})
        }
    }
	
    func configureAndAddAnimationToGradient( gradient : CAGradientLayer) {
		gradient.startPoint = CGPoint(x: -1.25, y: 0)
		gradient.endPoint = CGPoint(x: 1.25, y: 0)
        
        gradient.colors = [
            UIColor.backgroundFadedGrey().cgColor,
            UIColor.gradientFirstStop().cgColor,
            UIColor.gradientSecondStop().cgColor,
            UIColor.gradientFirstStop().cgColor,
            UIColor.backgroundFadedGrey().cgColor
        ]
        
        gradient.locations = [NSNumber(value: -1.25),NSNumber(value:-1.25),NSNumber(value:0),NSNumber(value: 0.25),NSNumber(value: 1.25)]
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [NSNumber(value: 0.0),NSNumber(value:0.0),NSNumber(value:0.10),NSNumber(value: 0.25),NSNumber(value: 1)]
        
        gradientAnimation.toValue = [NSNumber(value: 0),NSNumber(value:1),NSNumber(value:1),NSNumber(value: 1.15),NSNumber(value: 1.25)]
        
        gradientAnimation.repeatCount = Float.infinity
        gradientAnimation.fillMode = kCAFillModeForwards
        gradientAnimation.isRemovedOnCompletion = false
        
        gradientAnimation.duration = 1
        gradient.add(gradientAnimation ,forKey:"locations")
        
        self.setGradient(aLayer: gradient)
    }
    
    func addShimmerView() {
		let cutout = ShimmmerView(frame: self.bounds)
		
        self.insertSubview(cutout, at: 1)
        cutout.setNeedsDisplay()
		
        self.subviews.forEach {
            if $0 != cutout {
                $0.alpha = 0
            }
        }
        self.setCutoutView(aView: cutout)
    }
}

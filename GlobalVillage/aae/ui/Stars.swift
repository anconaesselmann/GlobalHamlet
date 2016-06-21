import Foundation
import UIKit

@IBDesignable class Stars: UIView {
    @IBInspectable var marked:Int {
        didSet {
            if marked >= 0 {
                setStars()
            }
        }
    }
    @IBInspectable var shaded:Int {
        didSet {
            if shaded >= 0 {
                setStars()
            }
        }
    }
    @IBInspectable var nbrStars:Int {
        didSet {
            if nbrStars > 0 {
                setStars()
            }
        }
    }
    var stars       = [UIImageView]()
    var starsEmpty  = [UIImageView]()
    var starsShaded = [UIImageView]()
    var starName = "star"
    var soundCallback:(()->Void)!
    
    func removeSetStars() {
        for star in stars {
            star.removeFromSuperview()
        }
        stars = [UIImageView]()
    }
    
    func setStars() {
        removeSetStars()

        let center = self.center
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        if stars.count > 0 {
            for star in stars {
                star.removeFromSuperview()
            }
            stars = [UIImageView]()
        }
        if starsEmpty.count == 0 {
            for i in 0.stride(to: nbrStars, by: 1) {
                guard let image = UIImage(named: "\(starName)Light") else {
                    print("could not load starLight image resource")
                    return
                }
                let size:CGSize = CGSize(width: image.size.width, height: image.size.height)
                let origin = CGPoint(x: CGFloat(i) * size.width, y: 0)
                let imageView = UIImageView.init(frame: CGRect(origin: origin, size: size))
                imageView.image = image
                starsEmpty.append(imageView)
                self.insertSubview(imageView, atIndex: 0)
            }
        }
        if starsShaded.count == 0 && shaded > 0 {
            for i in 0.stride(to: shaded, by: 1) {
                guard let image = UIImage(named: "\(starName)Shaded") else {
                    print("could not load starDark image resource")
                    return
                }
                let size:CGSize = CGSize(width: image.size.width, height: image.size.height)
                let origin = CGPoint(x: CGFloat(i) * size.width, y: 0)
                let imageView = UIImageView.init(frame: CGRect(origin: origin, size: size))
                imageView.image = image
                starsShaded.append(imageView)
                self.insertSubview(imageView, atIndex: 0)
            }
        }
        for i in 0.stride(to: marked, by: 1) {
            guard let image = UIImage(named: "\(starName)Dark") else {
                print("could not load starDark image resource")
                return
            }
            let size:CGSize = CGSize(width: image.size.width, height: image.size.height)
            let origin = CGPoint(x: CGFloat(i) * size.width, y: 0)
            let imageView = UIImageView.init(frame: CGRect(origin: origin, size: size))
            imageView.image = image
            stars.append(imageView)
            self.insertSubview(imageView, atIndex: 10)
        }
        guard starsEmpty.count > 0 else {return}
        self.frame.size.width = starsEmpty[0].image!.size.width * CGFloat(nbrStars)
        self.frame.size.height = starsEmpty[0].image!.size.height
        self.center = center
    }
    func incrementWithAnimation() {
        incrementWithAnimation() {}
    }
    func incrementWithAnimation(completionCallback:(()->Void)) {
        guard marked < nbrStars else {return}
        let prevSize = starsEmpty[0].frame.size
        let position = starsEmpty[marked].center
        let newStar = UIImage(named: "\(starName)Dark")
        let newStarImageView = UIImageView.init(frame: CGRect(origin: position, size: CGSize(width: 0.0, height: 0.0)))
        newStarImageView.image = newStar
        insertSubview(newStarImageView, atIndex: 0)
        bringSubviewToFront(newStarImageView)
        if soundCallback != nil {
            soundCallback()
        }
        UIView.animateWithDuration(
            0.25,
            animations: {
                newStarImageView.frame.size = CGSize(width: prevSize.width * 1.5, height:  prevSize.height * 1.5)
                newStarImageView.center = position
            },
            completion: { [unowned self] success in
                //                self.stars[self.marked].removeFromSuperview()
                self.stars.append(newStarImageView)
                self.marked += 1
                completionCallback()
            }
        )
    }
    func setStarsAnimated(stars:Int) {
        if self.marked < stars {
            incrementWithAnimation() { [unowned self] in
                self.setStarsAnimated(stars)
            }
        }
    }
    func decrementWithAnimation() {
        guard marked > 0 else {return}
        let prevSize = stars[marked - 1].frame.size
        let position = stars[marked - 1].center
        UIView.animateWithDuration(
            0.5,
            animations: { [unowned self] in
                self.stars[self.marked - 1].frame.size = CGSize(width: prevSize.width * 0.5, height:  prevSize.height * 0.5)
                self.stars[self.marked - 1].center = position
            },
            completion: { [unowned self] success in
                self.marked -= 1
            }
        )
        
    }
    func releaseResources() {
        for star in stars {
            star.removeFromSuperview()
        }
    }
    
    init(center:CGPoint) {
        nbrStars = -1
        marked   = -1
        shaded   = -1
        let size:CGSize = CGSize(width: 0,height: 0)
        super.init(frame: CGRect(origin: center, size: size))
    }
    required init?(coder aDecoder: NSCoder) {
        nbrStars = -1
        marked   = -1
        shaded   = -1
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        nbrStars = -1
        marked   = -1
        shaded   = -1
        super.init(frame: frame)
    }

}
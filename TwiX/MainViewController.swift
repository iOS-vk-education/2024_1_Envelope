import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.text = "Hello, world!"
        label.textAlignment = .center
        label.frame = self.view.bounds

        self.view.addSubview(label)
    }
}

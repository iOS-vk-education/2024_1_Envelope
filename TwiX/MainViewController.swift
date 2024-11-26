import UIKit

final class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.text = "Hello, world!"
        label.textAlignment = .center

        view.addSubview(label)
    }
}

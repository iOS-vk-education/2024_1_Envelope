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
    
    func setupNavBar() {
        navigationItem.title = Strings.App.name
        
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = profileButton

        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = settingsButton
                                             
    }
}

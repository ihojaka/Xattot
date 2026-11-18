import UIKit
class ViewController: UIViewController {
 override func viewDidLoad(){ super.viewDidLoad(); view.backgroundColor = .white
  let l = UILabel(frame: CGRect(x:20,y:120,width: view.bounds.width-40,height:120))
  l.text = "Xattot o'rnatildi!\nSozlamalar > Umumiy > Klaviatura > Klaviatura qo'shish > Xattot > To'liq ruxsat bering"; l.numberOfLines=0; l.textAlignment = .center
  view.addSubview(l)
 }
}

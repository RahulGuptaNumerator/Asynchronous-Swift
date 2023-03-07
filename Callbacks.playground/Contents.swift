//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Combine

protocol ServiceProtocol {
    var responseFromServer: ((Data) -> Void)? { get set }
    func callApi()

    func getResponseFromAPI(completion: @escaping (Data)->Void)
}
class Service: ServiceProtocol {
    var responseFromServer: ((Data) -> Void)?
    func callApi() {

        defer{
            responseFromServer?(Data())
        }
        print("Callback Property Response Created")
    }

    func getResponseFromAPI(completion: @escaping (Data)->Void) {

        defer{
            completion(Data())
        }
        print("Callback Function Response Created")
    }

}
protocol ViewModelProtocol {
    func fetchData()
}
class ViewModel: ViewModelProtocol {
    private var serviceObj: any ServiceProtocol
    init(service: any ServiceProtocol) {
        self.serviceObj = service
        fetchData()
    }
    func fetchData() {
        serviceObj.responseFromServer = { _ in
            print("Callback Property Response received")
        }
        serviceObj.callApi()

        serviceObj.getResponseFromAPI{ _ in
            print("Callback Function Response received")
        }
    }
}

class MyViewController : UIViewController {
    var vm: (any ViewModelProtocol)?
    func afterLoad() {
        let service = Service()
        vm = ViewModel(service: service)
    }


    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
        afterLoad()
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

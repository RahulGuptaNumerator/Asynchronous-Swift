//: A UIKit based Playground for presenting user interface
  
//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import Combine

protocol ServiceProtocol {
    var responseFromServerUsingFuture: Future<Data, Never>? { get set }
    @discardableResult
    func callApiUsingFuture() -> Self
    func getResponseFromAPIUseingFuture() -> Future<Data, Never>
}
class Service: ServiceProtocol {
    var responseFromServerUsingFuture: Future<Data, Never>?

    @discardableResult
    func callApiUsingFuture() -> Self {
        responseFromServerUsingFuture = Future { promise in
            defer{
                promise(.success(Data()))
            }
            print("Future Property Response Created")
        }
        return self
    }

    func getResponseFromAPIUseingFuture() -> Future<Data, Never> {
        return Future { promise in
            defer {
                promise(.success(Data()))
            }
            print("Future Function Response Created")
        }
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
        serviceObj.callApiUsingFuture()
            .responseFromServerUsingFuture?
            .sink { _ in
                print("Future Property Response received")
            }

        serviceObj.getResponseFromAPIUseingFuture()
            .sink { _ in
                print("Future Function Response received")
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

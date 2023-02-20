import Foundation

public protocol BaseCoordinatable: AnyObject {
    func start()
    func add(coordinatable: BaseCoordinatable)
    func remove(coordinatable: BaseCoordinatable)

    var childCoordinators: [BaseCoordinatable] { get set }
}

public extension BaseCoordinatable {
    func add(coordinatable: BaseCoordinatable) {
        guard !childCoordinators.contains(where: {
            $0 === coordinatable
        }) else {
            return
        }
        childCoordinators.append(coordinatable)
    }
    
    func remove(coordinatable: BaseCoordinatable) {
        if childCoordinators.isEmpty { return }
        if !coordinatable.childCoordinators.isEmpty {
            coordinatable.childCoordinators
                .filter {
                    $0 !== coordinatable
                }
                .forEach {
                    coordinatable.remove(coordinatable: $0)
                }
        }
        for (index, element) in childCoordinators.enumerated() where element === coordinatable {
            childCoordinators.remove(at: index)
            break
        }
    }
}

public protocol DatelessCoordinatable: StatelessCompletionable {}
public protocol Coordinatable: Completionable {}

public protocol Completionable {
    associatedtype ReturnData
    var completion: ((ReturnData) -> Void)? { get set }
}

public protocol StatelessCompletionable {
    var completion: (() -> Void)? { get set }
}

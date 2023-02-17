import Foundation

public protocol Coordinatable: StatelessCompletionable, AnyObject {
    func start()
    func add(coordinatable: Coordinatable)
    func remove(coordinatable: Coordinatable)

    var childCoordinators: [Coordinatable] { get set }
}

public extension Coordinatable {
    func add(coordinatable: Coordinatable) {
        guard !childCoordinators.contains(where: {
            $0 === coordinatable
        }) else {
            return
        }
        childCoordinators.append(coordinatable)
    }
    
    func remove(coordinatable: Coordinatable) {
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

public protocol Completionable {
    associatedtype ReturnData
    var completion: ((ReturnData) -> Void)? { get set }
}

public protocol StatelessCompletionable {
    var completion: (() -> Void)? { get set }
}

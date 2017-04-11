//
//  ConstraintSatisfaction.swift
//  Pods
//
//  Created by Mathias Quintero on 2/8/17.
//
//

import Foundation

enum VariableInstance<Variable: Hashable, Value> {
    case solved(variable: Variable, value: Value)
    case unsolved(variable: Variable, possible: [Value])
    case impossible(variable: Variable)
}

extension VariableInstance {
    
    var simplified: VariableInstance {
        switch self {
        case .unsolved(let name, let values):
            if values.isEmpty {
                return .impossible(variable: name)
            }
            if values.count == 1 {
                return .solved(variable: name, value: values[0])
            }
            return self
        default:
            return self
        }
    }
    
    var variable: Variable {
        switch self {
        case .solved(let name, _):
            return name
        case .unsolved(let name, _):
            return name
        case .impossible(let name):
            return name
        }
    }
    
    var isSolved: Bool {
        switch simplified {
        case .solved:
            return true
        default:
            return false
        }
    }
    
    var values: [Value] {
        switch self {
        case .impossible:
            return .empty
        case .solved(_, let value):
            return [value]
        case .unsolved(_, let values):
            return values
        }
    }
    
}

extension VariableInstance {
    
    func removeImpossibleValues(regarding instances: [VariableInstance<Variable, Value>],
                                and constraints: [Constraint<Variable, Value>]) -> VariableInstance<Variable, Value> {
        
        let name = self.variable
        let values = self.values.filter {
            let solved = VariableInstance.solved(variable: name, value: $0.0)
            let instances = instances |> { $0 != solved } + solved
            return constraints.and { $0.works(with: instances) }
        }
        let instance: VariableInstance<Variable, Value> = .unsolved(variable: name, possible: values)
        return instance.simplified
    }
    
}

extension VariableInstance: Hashable {
    
    var hashValue: Int {
        return variable.hashValue
    }
    
}

func ==<A, B>(_ lhs: VariableInstance<A, B>, _ rhs: VariableInstance<A, B>) -> Bool {
    return lhs.variable == rhs.variable
}

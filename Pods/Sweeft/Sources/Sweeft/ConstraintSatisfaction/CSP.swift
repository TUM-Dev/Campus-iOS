//
//  CSP.swift
//  Pods
//
//  Created by Mathias Quintero on 2/8/17.
//
//

import Foundation

/// Moddels a Constraint Statisfaction Problem
public struct CSP<Variable: Hashable, Value> {
    
    public typealias VariableValueSpec = (name: Variable, possible: [Value])
    
    let variables: [VariableValueSpec]
    let constraints: [Constraint<Variable, Value>]
    
    public init(variables: [VariableValueSpec], constraints: [Constraint<Variable, Value>]) {
        self.variables = variables
        self.constraints = constraints
    }
}

public extension CSP where Value: CSPValue {
    
    public init(variables: [Variable], constraints: [Constraint<Variable, Value>]) {
        self.init(variables: variables => { (name: $0, possible: Value.all) },
                  constraints: constraints)
    }
    
    public init(constraints: [Constraint<Variable, Value>]) {
        let variables = constraints.flatMap { $0.variables }
        self.init(variables: variables.noDuplicates,
                  constraints: constraints)
    }
    
}

extension CSP {
    
    typealias Instance = VariableInstance<Variable, Value>
    
    func constraints(concerning variables: Variable...) -> [Constraint<Variable, Value>] {
        return self.constraints |> { variables.and(conjunctUsing: $0.variables.contains) }
    }
    
    func neighbours(of variable: Variable) -> [Variable] {
        let variables = constraints(concerning: variable).flatMap { $0.variables } |> { $0 != variable }
        return variables.noDuplicates
    }
    
    private func bestInstance(for instances: [Instance]) -> Instance? {
        let left = instances |> { !$0.isSolved }
        if left.count == instances.count {
            return left.argmin { self.neighbours(of: $0.variable).count }
        } else {
            return left.argmin { $0.values.count }
        }
    }
    
    private func removeImposibleValues(in instances: [Instance]) -> [Instance] {
        var solved = instances |> { $0.isSolved }
        let count = solved.count
        let instances = instances => { $0.removeImpossibleValues(regarding: instances,
                                                                 and: self.constraints(concerning: $0.variable)) }
        solved = instances |> { $0.isSolved }
        if count == solved.count {
            return instances
        } else {
            return removeImposibleValues(in: instances)
        }
        
    }
    
    private func solve(instances: [Instance]) -> [Instance]? {
        if instances.and(conjunctUsing: { $0.isSolved }) {
            return instances
        }
        guard let current = bestInstance(for: instances) else {
            return nil
        }
        let instances = instances |> { $0 != current }
        return current.values ==> nil ** { result, value in
            if let result = result {
                return result
            }
            let instances = self.removeImposibleValues(in: instances + .solved(variable: current.variable, value: value))
            return self.solve(instances: instances)
        }
    }
    
    /// Find a Solution for the problem
    public func solution() -> [Variable:Value]? {
        let instances = variables => Instance.unsolved
        let solution = solve(instances: instances as [Instance])
        return solution?.dictionaryWithoutOptionals { ($0.variable, $0.values.first) }
    }
    
}

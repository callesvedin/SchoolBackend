
import Foundation
import Vapor
import HTTP


final class AssignmentController {
    
    
    func addRoutes(drop:Droplet) {
        let assignmentsGroup = drop.grouped("assignments")
        assignmentsGroup.get(handler:index)
        assignmentsGroup.get(Assignment.self, handler:show)
        assignmentsGroup.post(handler:create)
        assignmentsGroup.delete(Assignment.self, handler:delete)
        assignmentsGroup.put(Assignment.self, handler:update)
        assignmentsGroup.get(Assignment.self, "vocables", handler:showVocables) 
    }
    
    
    func showVocables(request:Request,assignment:Assignment) throws -> ResponseRepresentable {
        let vocables = try assignment.vocables()
        return try JSON(node:vocables)
    }
    
    func index(request:Request) throws -> ResponseRepresentable {
        return try JSON(node:Assignment.all().makeNode())
    }
    
    func create(request:Request) throws -> ResponseRepresentable {
        var assignment = try request.assignment()
        try assignment.save()
        return assignment
    }
    
    func show(request:Request, assignment:Assignment) throws -> ResponseRepresentable {
        return assignment
    }
    
    func update(request:Request, assignment:Assignment) throws -> ResponseRepresentable {
        let new = try request.assignment()
        var assignment = assignment
        assignment.name = new.name
        
        try assignment.save()
        return assignment
    }
    
    func delete(request:Request, assignment:Assignment) throws -> ResponseRepresentable {
        try assignment.delete()
        return JSON([:])
    }
    
}

extension Request {
    func assignment() throws -> Assignment {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try Assignment(node:json)
    }
}

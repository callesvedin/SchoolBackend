import Vapor
import HTTP

final class AssignmentController {
    
    func addRoutes(drop:Droplet) {
        let assignmentsGroup = drop.grouped("assignments")
        
        assignmentsGroup.get(handler:index)
        assignmentsGroup.get(Assignment.parameter, handler:show)
        assignmentsGroup.post(handler:create)
        assignmentsGroup.delete(Assignment.parameter, handler:delete)
        assignmentsGroup.put(Assignment.parameter, handler:update)
        assignmentsGroup.get(Assignment.parameter, "vocables", handler:showVocables)
    }
    
    func showVocables(request:Request) throws -> ResponseRepresentable {
        let assignment = try request.parameters.next(Assignment.self)
        let vocables = try assignment.vocables.all()
        return try JSON(node:vocables)
    }
    
    func index(request:Request) throws -> ResponseRepresentable {
        return try JSON(node:Assignment.all().makeNode(in:nil))
    }
    
    func create(request:Request) throws -> ResponseRepresentable {
        let assignment = try request.assignment()
        try assignment.save()
        return try JSON(node:assignment.makeNode(in: nil))
    }
    
    func show(request:Request) throws -> ResponseRepresentable {
        let assignment = try request.parameters.next(Assignment.self)
        return try JSON(node:assignment.makeNode(in: nil))
    }
    
    func update(request:Request) throws -> ResponseRepresentable {
        let new = try request.assignment()
        let assignment = try request.parameters.next(Assignment.self)
        assignment.name = new.name
        
        try assignment.save()
        return try JSON(assignment.makeNode(in: nil))
    }
    
    func delete(request:Request) throws -> ResponseRepresentable {
        let assignment = try request.parameters.next(Assignment.self)
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

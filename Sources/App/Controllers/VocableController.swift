import Vapor
import HTTP
import FluentProvider


final class VocableController {
     
    func addRoutes(drop:Droplet) {        
        let vocablesGroup = drop.grouped("vocables")
        vocablesGroup.get(Vocable.parameter, handler:show)
        vocablesGroup.put(Vocable.parameter, handler:update)
        vocablesGroup.delete(Vocable.parameter, handler:delete)
        vocablesGroup.get(handler:index)
        vocablesGroup.post(handler:create)
    }
  

    func index(request:Request) throws -> ResponseRepresentable {
        return try JSON(node:Vocable.all().makeNode(in: nil))
    }
    
    func create(request:Request) throws -> ResponseRepresentable {
        let vocable = try request.vocable()
        try vocable.save()
        return try JSON(vocable.makeNode(in: nil))
    }
    
    func show(request:Request) throws -> ResponseRepresentable {
        let vocable = try request.parameters.next(Vocable.self)
        return try JSON(vocable.makeNode(in: nil))
    }
    
    func update(request:Request) throws -> ResponseRepresentable {
        let vocable = try request.parameters.next(Vocable.self)
        let new = try request.vocable()
        
        vocable.swedish = new.swedish
        vocable.english = new.english
        vocable.assignmentId = new.assignmentId
        try vocable.save()
        return try JSON(vocable.makeNode(in: nil))
    }
    
    func delete(request:Request) throws -> ResponseRepresentable {
        let vocable = try request.parameters.next(Vocable.self)
        try vocable.delete()
        return JSON([:])
    }
    
}

extension Request {
    func vocable() throws -> Vocable {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try Vocable(node:json)
    }
}

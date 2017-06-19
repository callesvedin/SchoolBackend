
//import Foundation
import Vapor
import HTTP

final class VocableController {
     
    func addRoutes(drop:Droplet) {        
        let vocablesGroup = drop.grouped("vocables")
        vocablesGroup.get(Vocable.self, handler:show)
        vocablesGroup.put(Vocable.self, handler:update)
        vocablesGroup.delete(Vocable.self, handler:delete)
        vocablesGroup.get(handler:index)
        vocablesGroup.post(handler:create)
    }
  

    func index(request:Request) throws -> ResponseRepresentable {
        return try JSON(node:Vocable.all().makeNode())
    }
    
    func create(request:Request) throws -> ResponseRepresentable {
        var vocable = try request.vocable()
        try vocable.save()
        return vocable
    }
    
    func show(request:Request, vocable:Vocable) throws -> ResponseRepresentable {
        return vocable
    }
    
    func update(request:Request, vocable:Vocable) throws -> ResponseRepresentable {
        let new = try request.vocable()
        var vocable = vocable
        vocable.swedish = new.swedish
        vocable.english = new.english
        vocable.assignmentId = new.assignmentId
        try vocable.save()
        return vocable
    }
    
    func delete(request:Request, vocable:Vocable) throws -> ResponseRepresentable {
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


import Foundation
import Vapor
import Fluent

final class Assignment:Model {
    var id:Node?
    var exists:Bool = false
    var name:String
    
    init(name:String) {
        self.id = nil
        self.name = name
    }
    
    init(node:Node, in context:Context) throws {
        self.id = node["id"]
        self.name = try node.extract("name")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node:[
            "id":id,
            "name":name
        ])
    }
    
  
    static func prepare(_ database: Database) throws {
        try database.create(entity, closure: { assignments in
            assignments.id()
            assignments.string("name")
        })
    }
    
  
    static func revert(_ database: Database) throws {
        try database.delete(entity)
    }
}


extension Assignment {
    func vocables() throws -> [Vocable] {
        return try children(nil,Vocable.self).all()
    }
}

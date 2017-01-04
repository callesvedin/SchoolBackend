
import Foundation
import Vapor
import Fluent

final class Vocable:Model {
    var id:Node?
    var exists:Bool = false
    var assignmentId: Node?
    var swedish:String
    var english:String
    
    init(assignmentId:Node?, swedish:String, english:String) {
        self.id = nil
        self.assignmentId=assignmentId
        self.swedish = swedish
        self.english = english
    }
    
    init(node:Node, in context:Context) throws {
        self.id = node["id"]
        self.assignmentId = try node.extract("assignment_id")
        self.swedish = try node.extract("swedish")
        self.english = try node.extract("english")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node:[
            "id":self.id,
            "assignment_id":self.assignmentId,
            "swedish":self.swedish,
            "english":self.english
        ])
    }
    
    
    static func prepare(_ database: Database) throws {
        try database.create(entity, closure: { creator in
            creator.id()
            creator.string("swedish")
            creator.string("english")
            creator.parent(Assignment.self, optional:false)
        }
        )
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("vocables")
    }
}

extension Vocable {
    func assignment() throws -> Assignment? {
        return try parent(assignmentId,nil,Assignment.self).get()
    }
}

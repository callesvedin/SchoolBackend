
import Vapor
import FluentProvider

final class Vocable:NodeInitializable, NodeRepresentable, Model {
    static let foreignIdKey = "vocable_id"
    let storage = Storage()
    var exists:Bool = false
    var swedish:String
    var english:String
    var assignmentId:Identifier
    
    init(assignmentId:Identifier,swedish:String, english:String) {
        self.assignmentId = assignmentId
        self.swedish = swedish
        self.english = english
        
    }
    
    init(node:Node, in context:Context) throws {
        self.assignmentId = try node.get("assignment_id")
        self.swedish = try node.get("swedish")
        self.english = try node.get("english")
    }
    
    init(node:Node) throws {
        self.assignmentId = try node.get("assignment_id")
        self.swedish = try node.get("swedish")
        self.english = try node.get("english")
    }
    
    
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("id", self.id)
        try node.set("assignment_id", self.assignmentId)
        try node.set("swedish", self.swedish)
        try node.set("english", self.english)
        return node
        
    }
    
    public required init(row: Row) throws {
        assignmentId = try row.get(Assignment.foreignIdKey)
        swedish = try row.get("swedish")
        english = try row.get("english")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("swedish", swedish)
        try row.set("english", english)
        try row.set(Assignment.foreignIdKey, assignmentId)
        return row
    }
}

extension Vocable: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { vocables in
            vocables.id()
            vocables.string("swedish")
            vocables.string("english")
            vocables.parent(Assignment.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}


extension Vocable {
    var assignment:Parent<Vocable, Assignment>{
        return parent(id:assignmentId)
    }
}

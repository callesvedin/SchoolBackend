import Foundation
import Vapor
import FluentProvider

final class Assignment:NodeInitializable, NodeRepresentable, Model {
    static let foreignIdKey = "assignment_id"
    let storage = Storage()
    var exists:Bool = false
    var name:String
    var dueDate:Date?
    
    init(name:String, dueDate:Date? = nil) {
        self.name = name
        self.dueDate = dueDate ?? Date()
    }
    
    init(node:Node) throws {
        self.name = try node.get("name")
        self.dueDate = try node.get("due")
    }
    
    init(node:Node, in context:Context) throws {
        self.name = try node.get("name")
        self.dueDate = try node.get("due")
    }
    
    func makeNode(in context: Context?) throws -> Node {
        var node=Node(context)
        try node.set("id", self.id)
        try node.set("name",name)
        try node.set("due",dueDate)
        
        if let context = context as? ObjectContext<String, Bool> {
            if let inWeb = context.object["inWeb"]
            {
                if (inWeb == true){
                    try node.set("dueDateAsString", self.dueDateAsString)
                }
            }
        }
        return node
    }
    
    
    init(row: Row) throws {
        name = try row.get("name")
        dueDate = try row.get("due")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("due", dueDate)
        return row
    }
    
}

extension Assignment:Preparation {
        static func prepare(_ database: Database) throws {
            try database.create(self) { assignments in
                assignments.id()
                assignments.string("name")
                assignments.date("due")
            }
        }
    
        static func revert(_ database: Database) throws {
            try database.delete(self)
        }
}

extension Assignment {
    var vocables:Children<Assignment, Vocable> {
        return children()
    }
}

extension Assignment {
    var dueDateAsString:String {
        get {
            guard let due = dueDate else {
                return ""
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: due)
            
        }
    }
}

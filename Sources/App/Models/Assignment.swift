
import Foundation
import Vapor
import Fluent

final class Assignment:Model {
    var id:Node?
    var exists:Bool = false
    var name:String
    var dueDate:Date?
    
    init(name:String, dueDate:Date? = nil) {
        self.id = nil
        self.name = name
        self.dueDate = dueDate ?? Date()
    }
    
    init(node:Node, in context:Context) throws {
        self.id = node["id"]
        self.name = try node.extract("name")
        let due:Double = try node.extract("due")
        if due>0 {
            self.dueDate = Date.init(timeIntervalSince1970: due)
        }else{
            self.dueDate = nil
        }
    }
    
    func makeNode(context: Context) throws -> Node {
        
        if let context = context as? Dictionary<String, Any>, let inWeb = context["inWeb"] as? Bool, inWeb == true {
            return try Node(node:[
                "id":id,
                "name":name,
                "due":dueDate?.timeIntervalSince1970,
                "dueDateAsString":self.dueDateAsString
            ])
        }else{
            return try Node(node:[
                "id":id,
                "name":name,
                "due":dueDate?.timeIntervalSince1970
            ])
        }        
    }
    
        
    static func prepare(_ database: Database) throws {
        try database.create(entity, closure: { assignments in
            assignments.id()
            assignments.string("name")
            assignments.double("due")
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
        set(dateString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dueDate = dateFormatter.date(from: dateString)!
        }
    }
}

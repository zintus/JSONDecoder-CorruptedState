import Foundation

struct Foo: Decodable {
    enum Error: Swift.Error {
        case mistake
    }
    
    public init(from decoder: Decoder) throws {
        throw Error.mistake
    }
}

struct FooHolder: Decodable {
    let foo: Foo
}

struct Bar: Decodable {
    let baz: String
}

struct Union: Decodable {
    let result: Decodable
    
    let tryToDecodeNestedFailingObject = false
    
    public init(from decoder: Decoder) throws {
        if tryToDecodeNestedFailingObject {
            do {
                self.result = try FooHolder(from: decoder)
            } catch let error {
                print(error)
                self.result = try! Bar(from: decoder)
            }
        } else {
            self.result = try! Bar(from: decoder)
        }
    }
}

let jsonData = try! JSONSerialization.data(withJSONObject: ["baz": "value", "foo": [:]])

let decoder = JSONDecoder()
let root = try? decoder.decode(Union.self, from: jsonData)

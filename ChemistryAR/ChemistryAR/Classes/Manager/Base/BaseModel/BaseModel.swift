//
//  BaseModel.swift
//  ChemistryAR
//
//  Created by Admin on 10/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

public enum JSONValue<T:Codable>: Codable {
    
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case model(T)
    case arrModel([T])
    case arrString([String])
    case object([String: JSONValue])
    case array([JSONValue])
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try ((try? container.decode(String.self)).map(JSONValue.string))
            .or((try? container.decode(Int.self)).map(JSONValue.int))
            .or((try? container.decode(Double.self)).map(JSONValue.double))
            .or((try? container.decode(Bool.self)).map(JSONValue.bool))
            .or((try? container.decode(T.self)).map(JSONValue.model))
            .or((try? container.decode([T].self)).map(JSONValue.arrModel))
            .or((try? container.decode([String].self)).map(JSONValue.arrString))
            .or((try? container.decode([String: JSONValue].self)).map(JSONValue.object))
            .or((try? container.decode([JSONValue].self)).map(JSONValue.array))
            .resolve(with: DecodingError.typeMismatch(JSONValue.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON")))
    }
    
    //MARK: Help method
    func getArrayString() -> [String]? {
        switch self {
        case .arrString(let arr):
            return arr
        default:
            return nil
        }
    }
    
    func getString() -> String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
    
    func getModel() -> T? {
        switch self {
        case .model(let model):
            return model
        default:
            return nil
        }
    }
    
    func getArrayModel() -> [T]? {
        switch self {
        case .arrModel(let arrModel):
            return arrModel
        default:
            return nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        //
    }
}

class BaseModel: NSObject {
 
    func getDataObject() -> Data  {
        return  Data()
    }
 
    func getJSONObject(method: ParamsMethod) -> Any {
        return getDataObject()
    }
}

extension Decodable{
    func DecodeModel<T:Codable>(data: Data) -> T?{
        var model:T? =  nil
        do {
            let decoder = JSONDecoder()
            model = try decoder.decode(T.self, from:data)
            
        } catch let err {
            print("Err:", err)
        }
        return model;
    }
}

extension Encodable{
    func EncodeModel<T:Codable>(model: T) -> Data{
        var data:Data = Data()
        do {
            data = try JSONEncoder().encode(model)
        } catch {
            print(error)
        }
        return data;
    }
}

extension Optional {
    func or(_ other: Optional) -> Optional {
        switch self {
        case .none: return other
        case .some: return self
        }
    }
    
    func resolve(with error: @autoclosure () -> Error) throws -> Wrapped {
        switch self {
        case .none: throw error()
        case .some(let wrapped): return wrapped
        }
    }
}

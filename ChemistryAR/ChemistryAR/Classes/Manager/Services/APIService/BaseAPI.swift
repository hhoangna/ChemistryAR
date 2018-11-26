//
//  BaseAPI.swift
//  ChemistryAR
//
//  Created by HHumorous on 11/14/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import Foundation
import Alamofire;


fileprivate var __identifier: UInt = 0;

protocol APIDataPresentable {
    var rawData: Data {get set}
}

typealias APIParams = [String: Any];
typealias GenericAPICallback<RESULT, ERROR> = (_ result: APIOutput<RESULT , ERROR>) -> Void;
typealias APICallback<RESULT> = GenericAPICallback<RESULT, APIError>;

class BaseAPI {
    
    fileprivate static var sharedAPI:BaseAPI?
    
    enum StatusCode: Int {
        case success = 200
        case invalidInput = 400
        case notAuthorized = 401
        case serverError = 721
        case tokenFail = 603
    }
    
    fileprivate let sessionManager: SessionManager;
    fileprivate let responsedCallbackQueue: DispatchQueue;
    
    static func shared() -> BaseAPI {
        if BaseAPI.sharedAPI == nil {
            let smConfig = URLSessionConfiguration.default
            smConfig.timeoutIntervalForRequest = 30;
            smConfig.requestCachePolicy = .reloadIgnoringCacheData
            let sessionMgr: SessionManager = SessionManager(configuration: smConfig);
            BaseAPI.sharedAPI = BaseAPI(sessionMgr: sessionMgr);
        }
        return BaseAPI.sharedAPI!;
    }
    
    
    init(sessionMgr:SessionManager) {
        sessionManager = sessionMgr;
        responsedCallbackQueue = DispatchQueue.init(label: "api_responsed_callback_queue");
    }
    
    fileprivate  func getHeaders() -> HTTPHeaders {
        
        let headers = ["Content-Type": "application/json",
                       "Accept": "application/json"]
        
        return headers
    }
    
    
    fileprivate func requestHeader(headers:HTTPHeaders?,
                                   url: String? = nil,
                                   method: ParamsMethod? = .GET,
                                   bodyData: Data? = nil,
                                   bodyString: String? = nil) -> HTTPHeaders {
        //fatalError("\(#function) should be implemented in \(ClassName(self))");
        var newHeaders = getHeaders()
        
        if let hds = headers {
            newHeaders = hds
        }
        // setToken
        if Caches().hasLogin  == true {
            newHeaders["Authorization"] = "Bearer \(Caches().token)"
        }
        
        return newHeaders;
    }
    
    func request<RESULT:Codable, ERROR: APIError>(method: ParamsMethod,
                                                  serverURL:String  = SERVER_URL.API,
                                                  headers:HTTPHeaders? = nil,
                                                  path: String,
                                                  input: APIInput,
                                                  hasUnstructured:Bool = false,
                                                  callback:@escaping GenericAPICallback<RESULT, ERROR>) -> APIRequest{
        
        __identifier += 1;
        
        let identifier = __identifier;
        
        let url = serverURL.appending(path)
        
        var alarmofireMethod: HTTPMethod;
        switch method {
        case .POST:
            alarmofireMethod = .post;
            break;
        case .PUT:
            alarmofireMethod = .put;
            break;
        case .PATCH:
            alarmofireMethod = .patch;
            break;
        case .DELETE:
            alarmofireMethod = .delete;
            break;
        default:
            alarmofireMethod = .get;
            break;
        }
        
        func APILog(_ STATUS: String, _ MSG: String?) {
            print(">>> [API]  [\( String(format: "%04u", identifier) )] [\( method )] [\( url )] \( STATUS )");
            if let msg = MSG { print("\( msg )\n\n"); }
        }
        
        let encoding = APIEncoding(input, method: method);
        
        let headers = requestHeader(headers: headers,
                                    url: url,
                                    method: method,
                                    bodyData: encoding.bodyDataValue,
                                    bodyString: encoding.bodyStringValue)
        
        APILog("REQUEST", encoding.bodyStringValue);
        
        let request: DataRequest;
        
        request = sessionManager.request(url,
                                         method: alarmofireMethod,
                                         parameters: [:],
                                         encoding: encoding,
                                         headers: headers);
        
        request.responseJSON(queue: responsedCallbackQueue, options: .allowFragments) { (dataResponse) in
            
            let result: APIOutput<RESULT, ERROR>;
            
            switch dataResponse.result {
            case .success(let object):
                result = self.handleResponse(dataResponse: dataResponse,
                                             object: object,
                                             hasUnstructured: hasUnstructured)
                
            case .failure(let error):
                result = self.handleFailure(dataResponse: dataResponse, error: error)
            }
            
            DispatchQueue.main.async {
                callback(result);
            }
            
            DispatchQueue.global(qos: .background).async {
                let logResult = dataResponse.data != nil ? String(data: dataResponse.data!, encoding: .utf8) : "<empty>";
                var logStatus : String;
                
                if let statusCode = dataResponse.response?.statusCode {
                    logStatus = String(statusCode);
                }else if let anError = dataResponse.error {
                    logStatus = "\(anError)";
                }else{
                    logStatus = "Unexpected Error!";
                }
                
                APILog("RESPONSE-\(logStatus)", logResult);
            }
            
        }
        
        return APIRequest(alarmofireDataRequest: request);
    }
    
    
    func uploadMultipartFormData<RESULT:Codable, ERROR: APIError>(method: ParamsMethod,
                                                                  serverURL:String  = SERVER_URL.API_FILE,
                                                                  headers:HTTPHeaders? = nil,
                                                                  path: String,
                                                                  input: [FileModel],
                                                                  callback:@escaping GenericAPICallback<RESULT, ERROR>) {
        
        __identifier += 1;
        
        let identifier = __identifier;
        
        let url = serverURL.appending(path);
        
        var alarmofireMethod: HTTPMethod;
        switch method {
        case .POST:
            alarmofireMethod = .post;
            break;
        case .PUT:
            alarmofireMethod = .put;
            break;
        case .PATCH:
            alarmofireMethod = .patch;
            break;
        case .DELETE:
            alarmofireMethod = .delete;
            break;
        default:
            alarmofireMethod = .get;
            break;
        }
        
        func APILog(_ STATUS: String, _ MSG: String? = nil) {
            print(">>> [API]  [\( String(format: "%04u", identifier) )] [\( method )] [\( path )] \( STATUS )");
            if let msg = MSG { print("\( msg )\n\n"); }
        }
        
        APILog("REQUEST");
        
        let headers = requestHeader(headers: headers) // Curently can't test with Sel2B server File
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for file  in input {
                multipartFormData.append(file.contentFile ?? Data(),
                                         withName: "attachment",
                                         fileName: E(file.originalname),
                                         mimeType: E(file.mimetype))
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
           to: url, method: .post, headers: headers) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    var result: APIOutput<RESULT, ERROR>;
                    
                    let logResult = response.data != nil ? String(data: response.data!, encoding: .utf8) : "<empty>";
                    var logStatus : String;
                    
                    if let statusCode = response.response?.statusCode {
                        logStatus = String(statusCode);
                    }else if let anError = response.error {
                        logStatus = "\(anError)";
                    }else{
                        logStatus = "Unexpected Error!";
                    }
                    
                    APILog("RESPONSE-\(logStatus)", logResult);
                    
                    
                    switch response.result {
                    case .success(let obj):
                        result = self.handleResponse(dataResponse: response, object: obj, hasUnstructured: true)
                        
                    case .failure(let error):
                        result = self.handleFailure(dataResponse: response, error: error)
                    }
                    
                    DispatchQueue.main.async {
                        callback(result);
                    }
                })
                
            case .failure(let error) :
                
                print(error)
                let err = APIError() as! ERROR
                err.message = error.localizedDescription
                
                var result: APIOutput<RESULT, ERROR>;
                result = .error(err)
                
                DispatchQueue.main.async {
                    callback(result);
                }
            }
        }
    }
}



fileprivate extension BaseAPI{
    struct HTTPResponse<T:Codable>: Codable {
        var message: String?
        var success:Bool = false
        var code: Int?
        var results:T?
        
        //        init(from decoder: Decoder) throws {
        //            let values = try decoder.container(keyedBy: CodingKeys.self)
        //            message = try values.decode(String.self, forKey: .message)
        //            success = try values.decode(Bool.self, forKey: .success)
        //            results = try values.decode(T.self, forKey: .results)
        //        }
    }
    
    func handleResponse<RESULT:Codable, ERROR: APIError>(dataResponse: DataResponse<Any>,
                                                         object: Any,
                                                         hasUnstructured:Bool) -> APIOutput<RESULT, ERROR> {
        
        let status: StatusCode = StatusCode(rawValue: (dataResponse.response?.statusCode)!) ?? .serverError
        switch status {
        case .success:
            
            var  objectResponse:HTTPResponse<RESULT>
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(.serverDateFormater)
                
                if hasUnstructured {
                    let obj:RESULT = try decoder.decode(RESULT.self, from: dataResponse.data ?? Data())
                    return .object(obj)
                    
                }else {
                    objectResponse = try decoder.decode(HTTPResponse<RESULT>.self, from: dataResponse.data ?? Data())
                    
                    let success:Bool = objectResponse.success
                    
                    if success {
                        if let obj = objectResponse.results{
                            return .object(obj)
                        }else {
                            
                            return .object(EmptyModel() as!RESULT)
                        }
                        
                    }else {
                        
                        let err = ERROR(dataResponse: dataResponse)
                        //err.message = E(objectResponse.message)
                        return .error(err)
                    }
                }
               
            } catch let err {
                print("Err:", err)
            }
            
            break;
            
        default:
            break;
        }
        
        let err = ERROR(dataResponse: dataResponse)
        return .error(err)
    }
    
    
    func handleFailure<RESULT, ERROR: APIError>(dataResponse: DataResponse<Any>, error: Error) -> APIOutput<RESULT, ERROR>  {
        let err = ERROR(dataResponse: dataResponse)
        err.message = error.localizedDescription;
        
        return .error(err)
    }
}

//MARK: - Encoding

extension BaseAPI {
    
    struct APIEncoding: ParameterEncoding {
        
        var bodyStringValue: String? = nil
        var bodyDataValue: Data? = nil
        
        init(_ theInput: APIInput, method: ParamsMethod) {
            
            func parseJson(_ rawObject: Any) -> (data: Data, string: String)? {
                
                guard let jsonData = (try? JSONSerialization.data(withJSONObject: rawObject, options: .init(rawValue: 0))) else {
                    print("Couldn't parse [\(rawObject)] to JSON");
                    return nil;
                }
                
                let jsonString = String(data: jsonData, encoding: .utf8)!;
                return (data: jsonData, string: jsonString);
            }
            
            switch theInput {
            case .empty:
                bodyStringValue = nil;
                bodyDataValue = nil;
                
            case .dto(let info):
                let params = info.getJSONObject(method: method)
                if (((params as? ResponseDictionary) != nil) ||
                    ((params as? ResponseArray) != nil))  {
                    
                    let jsonValues = parseJson(params);
                    bodyStringValue = jsonValues?.string;
                    bodyDataValue = jsonValues?.data;
                    
                }else if let prs = params as? Data {
                    bodyStringValue = String.init(data: prs, encoding: .utf8);
                    bodyDataValue = prs;
                }
                
            case .json(let jsonObject):
                let jsonValues = parseJson(jsonObject);
                bodyStringValue = jsonValues?.string;
                bodyDataValue = jsonValues?.data;
                
            case .str(let string, let inString):
                let sideString = inString ?? "";
                bodyStringValue = "\(sideString)\(string)\(sideString)";
                bodyDataValue = bodyStringValue?.data(using: .utf8, allowLossyConversion: true);
                
            case .data(let data):
                bodyStringValue = String.init(data: data, encoding: .utf8);
                bodyDataValue = data;
                
            case .mutiFile(let files):
                let data = getMutiDataFromFile(files: files)
                bodyStringValue = String.init(data: data, encoding: .utf8);
                bodyDataValue = data;
            }
        }
        
        
        func getMutiDataFromFile(files:[FileModel]) -> Data {
            let mutiData:NSMutableData = NSMutableData()
            
            for file in files {
                let data = file.getJSONObject(method: .POST)
                if let data = data as? Data {
                    mutiData.append(data);
                }else {
                    print("Data Invalid.")
                }
            }
            
            return mutiData as Data;
        }
        
        
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var request = try urlRequest.asURLRequest();
            request.httpBody = bodyDataValue;
            return request;
        }
    }
}

//MARK: - API Request

class APIRequest {
    
    private var alarmofireDataRequest: DataRequest? = nil;
    
    required init(alarmofireDataRequest request: DataRequest){
        alarmofireDataRequest = request;
    }
    
    func cancel() {
        if let request = alarmofireDataRequest {
            request.cancel();
        }
    }
    
}

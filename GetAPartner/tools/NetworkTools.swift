//
//  NetworkTools.swift
//  01-AFNetworking的封裝
//
//  Created by 游宗翰 on 2016/9/10.
//  Copyright © 2016年 han. All rights reserved.
//

import AFNetworking

enum RequestType:String {
    case get = "GET"
    case post = "POST"
}

class NetworkTools: AFHTTPSessionManager {

    static let shareInstance = { () -> NetworkTools in 
       let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()
}


extension NetworkTools {
    func request(methodType:RequestType, URLString:String, parameters:[String:AnyObject]?, finished:@escaping (_ result:Any?, _ err:Error?)->()) {
        
        let successCallBack = { (task:URLSessionDataTask, result:Any?) in
            finished(result, nil)
        }
        
        let failureCallBack = { (task:URLSessionDataTask?, err:Error) in
            finished(nil, err)
        }
        
        if methodType == .get {
            get(URLString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }else {
            post(URLString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

// MARK:- 請求首頁數據
extension NetworkTools {
    func loadAnimalData(finished: @escaping (_ result:[[String:AnyObject]]?, _ err:Error?) -> ()) {
        
        let urlString = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f4a75ba9-7721-4363-884d-c3820b0b917c"
        
        request(methodType: .get, URLString: urlString, parameters: nil) { (result, err) in
            
            guard let resultDic = result as? [String : AnyObject] else {
                finished(nil, err)
                return
            }
            //YULog(resultDic["result"]?["results"] as? [[String : AnyObject]])
            finished(resultDic["result"]?["results"] as? [[String : AnyObject]],err)
        }
    }
}

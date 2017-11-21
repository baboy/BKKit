//
//  BHttpRequestManager+Deprecated.m
//  Pods
//
//  Created by baboy on 4/3/15.
//
//

#import "BHttpRequestManager+Deprecated.h"

@implementation BHttpRequestManager(Deprecated)
/*
- (BHttpRequestOperation *)createDefaultHttpRequestOperationWithRequest:(NSURLRequest *)request
                                                                success:(void (^)(BHttpRequestOperation *operation, id responseObject))success
                                                                failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure{
    return [self createHttpRequestOperationWithRequest:request
                                    responseSerializer:[AFHTTPResponseSerializer serializer]
                                               success:^(BHttpRequestOperation *operation, id data, bool isReadFromCache) {
                                                   success(operation, data);
                                               }
                                               failure:failure];
}
- (BHttpRequestOperation *)createJsonHttpRequestOperationWithRequest:(NSURLRequest *)request
                                                             success:(void (^)(BHttpRequestOperation *operation, id responseObject))success
                                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure{
    return [self createHttpRequestOperationWithRequest:request
                                    responseSerializer:[AFJSONResponseSerializer serializer]
                                               success:^(BHttpRequestOperation *operation, id data, bool isReadFromCache) {
                                                   success(operation, data);
                                               } failure:failure];
}

- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                     userInfo:(id)userInfo
                                                      success:(void (^)(BHttpRequestOperation *operation, id responseObject))success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self requestWithGETURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createJsonHttpRequestOperationWithRequest:request success:success failure:failure];
    [operation setUserInfo:userInfo];
    [self.operationQueue addOperation:operation];
    
    return operation;
}



- (BHttpRequestOperation *)jsonRequestOperationWithGetRequest:(NSString *)URLString
                                                   parameters:(id)parameters
                                                      success:(void (^)(BHttpRequestOperation *operation, id responseObject))success
                                                      failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure{
    return [self jsonRequestOperationWithGetRequest:URLString parameters:parameters userInfo:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                       userInfo:(id)userInfo
                                                        success:(void (^)(BHttpRequestOperation *operation, id responseObject))success
                                                        failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self requestWithPOSTURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createJsonHttpRequestOperationWithRequest:request success:success failure:failure];
    [operation setUserInfo:userInfo];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
- (AFHTTPRequestOperation *)jsonRequestOperationWithPostRequest:(NSString *)URLString
                                                     parameters:(id)parameters
                                                        success:(void (^)(BHttpRequestOperation *operation, id responseObject))success
                                                        failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure{
    return [self jsonRequestOperationWithPostRequest:URLString parameters:parameters userInfo:nil success:success failure:failure];
}

- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                             success:(void (^)(BHttpRequestOperation *operation, id data))success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure{
    NSMutableURLRequest *request = [self requestWithPOSTURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createJsonHttpRequestOperationWithRequest:request success:success failure:failure];
    [operation setUserInfo:userInfo];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
- (BHttpRequestOperation *)dataRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                             success:(void (^)(BHttpRequestOperation *operation, id data))success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure{
    return [self dataRequestWithURLRequest:URLString parameters:parameters userInfo:nil success:success failure:failure];
}


- (BHttpRequestOperation *)fileRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                            userInfo:(id)userInfo
                                             success:(void (^)(BHttpRequestOperation *operation, id data))success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure{
    NSMutableURLRequest *request = [self requestWithPOSTURL:URLString parameters:parameters];
    BHttpRequestOperation *operation = [self createDefaultHttpRequestOperationWithRequest:request success:success failure:failure];
    [operation setCacheHandler:[BHttpRequestCacheHandler fileCacheHandler]];
    [self.operationQueue addOperation:operation];
    
    return operation;
}
- (BHttpRequestOperation *)fileRequestWithURLRequest:(NSString *)URLString
                                          parameters:(id)parameters
                                             success:(void (^)(BHttpRequestOperation *operation, id data))success
                                             failure:(void (^)(BHttpRequestOperation *operation, NSError *error))failure{
    return [self fileRequestWithURLRequest:URLString parameters:parameters userInfo:nil success:success failure:failure];
}
*/
@end

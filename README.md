# QLNetwork



/**
*  发送请求Block(在block内部配置request)
*/
[QLAction sharedQLAction].timeoutInterval = 10;
[[QLAction sharedQLAction] sendRequestBlock:^id(NSObject *request) {

    request.ql_url = [NSString stringWithFormat:@"%@/api/app/login", CommonURL];
    request.ql_method = QLRequestMethodPOST;
    request.ql_params = @{};

    DLog(@"%@--%@", request.ql_url, request.ql_params);

} progress:^(NSProgress *isProgress) {
    progressBlock(isProgress);
} success:^(id responseObject) {
    successBlock(responseObject);
} failure:^(NSError *error) {
    failureBlock(error);
}];

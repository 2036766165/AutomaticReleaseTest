//
//  WKNetWorkManager.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKNetWorkManager.h"
#import "WKGoodsModel.h"

static WKNetWorkManager *_wkNetWorkManager = nil;

@implementation WKNetWorkManager

+ (instancetype)shareNetWork{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _wkNetWorkManager = [[WKNetWorkManager alloc] init];
    });
    return _wkNetWorkManager;
}

- (void)requestWithMethod:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock{

    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)getAuthCode:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)loginWithMethod:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock{
    
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)loginOutApp:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)getGoodsList:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               model:(NSString *)model
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)getLiveGoodsList:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   model:(NSString *)model
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)goodsBatch:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)goodsTop:(HttpRequestMethod)httpRequestMethod
             url:(NSString *)url
           param:(NSDictionary *)param
         success:(SuccessBlock)successBlock
         failure:(FailureBlock)failureBlock{
     [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}


- (void)goodsDelete:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];

}

- (void)getPersonMessage:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   model:(NSString *)model
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)getRongToken:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               model:(NSString *)model
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)uploadImages:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
             fileArr:(NSArray<UIImage *> *)fileArr
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url model:nil fileArr:fileArr param:nil success:successBlock failure:failureBlock];
}

- (void)uploadGoods:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              model:(NSString *)model
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)getMemberMessageCount:(HttpRequestMethod)httpRequestMethod
                          url:(NSString *)url
                        model:(NSString*)model
                        param:(NSDictionary *)param
                      success:(SuccessBlock)successBlock
                      failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)myAttention:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              model:(NSString *)model
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)myFans:(HttpRequestMethod)httpRequestMethod
           url:(NSString *)url
         model:(NSString *)model
         param:(NSDictionary *)param
       success:(SuccessBlock)successBlock
       failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}


- (void)myIntegral:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             model:(NSString *)model
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}


- (void)searchHistory:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                model:(NSString *)model
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)myOrder:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          model:(NSString *)model
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)myOrderDetail:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                model:(NSString *)model
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)storeOrder:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             model:(NSString *)model
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)storeOrderDetail:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   model:(NSString *)model
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)storeOrderRemove:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)storeOrderPayOffline:(HttpRequestMethod)httpRequestMethod
                         url:(NSString *)url
                       model:(NSString *)model
                       param:(NSDictionary *)param
                     success:(SuccessBlock)successBlock
                     failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)personOrderRemove:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    model:(NSString *)model
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)personOrderCancel:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    model:(NSString *)model
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)getSystemTime:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                model:(NSString*)model
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock
{

    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}


- (void)storeOrderFixExpress:(HttpRequestMethod)httpRequestMethod
                         url:(NSString *)url
                       model:(NSString *)model
                       param:(NSDictionary *)param
                     success:(SuccessBlock)successBlock
                     failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)storeOrderSendShop:(HttpRequestMethod)httpRequestMethod
                       url:(NSString *)url
                     model:(NSString *)model
                     param:(NSDictionary *)param
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)getFollowAndNot:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  model:(NSString *)model
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)getBook:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          model:(NSString *)model
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

-(void)getTagMessage:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               model:(NSString *)model
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:nil model:model success:successBlock failure:failureBlock];
}

- (void)updateMemberInfo:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock{
     [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}


-(void)uploadTagMessage:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)getAddress:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             model:(NSString *)model
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock{
      [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}


-(void)addressAdd:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
             para:(NSDictionary *)para
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:para model:nil success:successBlock failure:failureBlock];

}

-(void)addressDelete:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
                para:(NSDictionary *)para
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    
    [self requestWithMethod:httpRequestMethod requestUrl:url param:para model:nil success:successBlock failure:failureBlock];
}

- (void)getAddreddInfo:(HttpRequestMethod)httpRequestMethod url:(NSString *)url model:(NSString *)model para:(NSDictionary *)para success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:para model:model success:successBlock failure:failureBlock];

}

-(void)loadingHomeHotPlay:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)loadingEvaluate:(HttpRequestMethod)httpRequestMethod
                   url:(NSString *)url
                 param:(NSDictionary *)param
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}


-(void)uploadStoreInfo:(HttpRequestMethod)httpRequestMethod
                   url:(NSString *)url
                 param:(NSDictionary *)param
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)storeIncome:(HttpRequestMethod)httpRequestMethod
                   url:(NSString *)url
                 param:(NSDictionary *)param
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)getSellerBindCode:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)punishWith:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
            param:(NSDictionary *)param
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)recommendGoods:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)deleteRecommendGoods:(HttpRequestMethod)httpRequestMethod url:(NSString *)url param:(NSDictionary *)param success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];

}

-(void)userWithdraw:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)incomeDetails:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)incomeDetailsMessage:(HttpRequestMethod)httpRequestMethod
                        url:(NSString *)url
                      param:(NSDictionary *)param
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)auctionDetailMessage:(HttpRequestMethod)httpRequestMethod
                        url:(NSString *)url
                      param:(NSDictionary *)param
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)homeHotSaleMessage:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)UserDetailsMessage:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)AuctionStatus:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               model:(NSString *)model
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}


-(void)AuctionJoin:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             model:(NSString *)model
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)GoodsInfo:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
            param:(NSDictionary *)param
            model:(NSString *)model
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

-(void)GoodsGet:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          model:(NSString *)model
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

-(void)GoodsCommentList:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  model:(NSString *)model
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

-(void)GetMemberByBPOID:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  model:(NSString *)model
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

-(void)customTableMessage:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                    param:(NSDictionary *)param
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

// 拍卖商品
- (void)auctionGoods:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
               model:(NSString *)model
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

// 开始直播
- (void)showStart:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
            param:(NSDictionary *)param
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)Payment:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          param:(NSDictionary *)param
          model:(NSString *)model
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)FixTranFee:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
             model:(NSString *)model
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

-(void)addComment:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
            param:(NSDictionary *)param
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)CommentNumber:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod url:url param:param success:successBlock failure:failureBlock];
}

-(void)CustomComment:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod url:url param:param success:successBlock failure:failureBlock];
}

-(void)SendShopDetails:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod url:url param:param success:successBlock failure:failureBlock];
}

- (void)getShowMemberInfo:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    model:(NSString *)model
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

- (void)offLinePay:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)showPause:(HttpRequestMethod)httpRequestMethod url:(NSString *)url param:(NSDictionary *)param success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)normalPay:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
            param:(NSDictionary *)param
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

- (void)checkStarStatus:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];

}

-(void)ReplyComment:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)QuickBuy:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          model:(NSString *)model
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}


-(void)PlayHistory:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             model:(NSString *)model
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

-(void)GetStoreTranFee:(HttpRequestMethod)httpRequestMethod
                   url:(NSString *)url
                 model:(NSString *)model
                 param:(NSDictionary *)param
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

-(void)GetShopAuthentication:(HttpRequestMethod)httpRequestMethod
                         url:(NSString *)url
                       model:(NSString *)model
                       param:(NSDictionary *)param
                     success:(SuccessBlock)successBlock
                     failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

-(void)OrderPayStatus:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                model:(NSString *)model
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock
{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:model success:successBlock failure:failureBlock];
}

-(void)downLoadVoice:(HttpRequestMethod)httpRequestMethod url:(NSString *)url param:(NSDictionary *)param success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)uploadMessage:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)uploadPrompt:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)orderRecharge:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)applePayLoading:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)jumpHome:(HttpRequestMethod)httpRequestMethod
                   url:(NSString *)url
                 param:(NSDictionary *)param
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)isSaleNetwork:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)sendBarrageMessage:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)personalCenter:(HttpRequestMethod)httpRequestMethod url:(NSString *)url param:(NSDictionary *)param success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
     [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}
- (void)getScrollImage:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)shareWeChatBefore:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)shareWeChatAfter:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)userAccount:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)LaunchFlockRedPacket:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)LaunchOnceRedPacket:(HttpRequestMethod)httpRequestMethod
                        url:(NSString *)url
                      param:(NSDictionary *)param
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)RedPacketDetails:(HttpRequestMethod)httpRequestMethod
                       url:(NSString *)url
                     param:(NSDictionary *)param
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

-(void)RedBagConfig:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock{
    [self requestWithMethod:httpRequestMethod requestUrl:url param:param model:nil success:successBlock failure:failureBlock];
}

@end

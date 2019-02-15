//
//  WKNetWorkManager.h
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseNetWork.h"

@interface WKNetWorkManager : WKBaseNetWork

/*
 * 网络是否可以
 */
@property (nonatomic,assign) BOOL isNetworkEnable;

+ (instancetype)shareNetWork;
// MARK: guohb
/*
 *获取验证码
 */
- (void)getAuthCode:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;

/*
 * 登录
 */
- (void)loginWithMethod:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock;

/**
 *  退出账号
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)loginOutApp:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock;



/**
 *  获取个人信息
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)getPersonMessage:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   model:(NSString *)model
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;

/**
 *  获取融云token
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)getRongToken:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   model:(NSString *)model
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;

/*
 * 上传图片
 */
- (void)uploadImages:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               fileArr:(NSArray *)fileArr
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

/***************************商品接口****************************************/
/*
 *获取商品列表
 */
- (void)getGoodsList:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               model:(NSString *)model
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

/*
 *获取观看端商品列表
 */
- (void)getLiveGoodsList:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               model:(NSString *)model
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

/*
 * 上传商品
 */
- (void)uploadGoods:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   model:(NSString *)model
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;

- (void)goodsBatch:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;

// 商品置顶
- (void)goodsTop:(HttpRequestMethod)httpRequestMethod
             url:(NSString *)url
           param:(NSDictionary *)param
         success:(SuccessBlock)successBlock
         failure:(FailureBlock)failureBlock;

// 删除商品
- (void)goodsDelete:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock;

/***************************商品接口****************************************/

/**
 *  我的关注(关注)
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)myAttention:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             model:(NSString *)model
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;

/**
 *  我的关注(粉丝)
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)myFans:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              model:(NSString *)model
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock;

/**
 *  我的积分
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)myIntegral:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                model:(NSString *)model
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock;

/**
 *  查询历史记录
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)searchHistory:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                model:(NSString *)model
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock;



// 修改个人信息
- (void)updateMemberInfo:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock;

/**
 *  获取用户的统计信息
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)getMemberMessageCount:(HttpRequestMethod)httpRequestMethod
                          url:(NSString *)url
                        model:(NSString*)model
                        param:(NSDictionary *)param
                      success:(SuccessBlock)successBlock
                      failure:(FailureBlock)failureBlock;

/**
 *  获取系统时间
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)getSystemTime:(HttpRequestMethod)httpRequestMethod
                          url:(NSString *)url
                        model:(NSString*)model
                        param:(NSDictionary *)param
                      success:(SuccessBlock)successBlock
                      failure:(FailureBlock)failureBlock;

// 地址信息接口
- (void)getAddress:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   model:(NSString *)model
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;
/**
 *  我的订单查询
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)myOrder:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             model:(NSString *)model
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;

/**
 *  我的订单详情
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)myOrderDetail:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          model:(NSString *)model
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock;
/**
 *  店铺订单查询
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)storeOrder:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                model:(NSString *)model
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock;


/**
 *  店铺订单详情
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)storeOrderDetail:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             model:(NSString *)model
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;


/*
 *  店铺订单删除
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)storeOrderRemove:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             model:(NSString *)model
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;


/*
 *  个人订单取消
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)personOrderCancel:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    model:(NSString *)model
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;
/*
 *  店铺线下支付
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)storeOrderPayOffline:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   model:(NSString *)model
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;

/*
 *  个人订单删除
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)personOrderRemove:(HttpRequestMethod)httpRequestMethod
                         url:(NSString *)url
                       model:(NSString *)model
                       param:(NSDictionary *)param
                     success:(SuccessBlock)successBlock
                     failure:(FailureBlock)failureBlock;

/*
 *  店铺订单快递单号修改
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)storeOrderFixExpress:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    model:(NSString *)model
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;

/*
 *  店铺订单发货
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)storeOrderSendShop:(HttpRequestMethod)httpRequestMethod
                         url:(NSString *)url
                       model:(NSString *)model
                       param:(NSDictionary *)param
                     success:(SuccessBlock)successBlock
                     failure:(FailureBlock)failureBlock;
/**
 *  关注,取消关注
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)getFollowAndNot:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               model:(NSString *)model
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

/**
 *  获取通讯录
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
- (void)getBook:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  model:(NSString *)model
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock;

/**
 获取标签信息
 @param httpRequestMethod
 @param url
 @param model
 @param successBlock
 @param failureBlock
 */
-(void)getTagMessage:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               model:(NSString *)model
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

// 添加地址
-(void)addressAdd:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               para:(NSDictionary *)para
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

// 删除地址
-(void)addressDelete:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
             para:(NSDictionary *)para
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock;

// 获取地址详情
-(void)getAddreddInfo:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
                model:(NSString *)model
                para:(NSDictionary *)para
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;
/**
 上传标签

 @param httpRequestMethod
 @param url               
 @param model             
 @param param             
 @param successBlock      
 @param failureBlock
 */
-(void)uploadTagMessage:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock;

/**
 首页热门
 @param httpRequestMethod 
 @param url               
 @param param             
 @param successBlock      
 @param failureBlock
 */
-(void)loadingHomeHotPlay:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;


/**
 评价晒单
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)loadingEvaluate:(HttpRequestMethod)httpRequestMethod
                   url:(NSString *)url
                 param:(NSDictionary *)param
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock;

// 上传店铺消息
-(void)uploadStoreInfo:(HttpRequestMethod)httpRequestMethod
                           url:(NSString *)url
                         param:(NSDictionary *)param
                       success:(SuccessBlock)successBlock
                       failure:(FailureBlock)failureBlock;

// 处罚申诉
-(void)punishWith:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
            param:(NSDictionary *)param
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock;
/**
 客户收入
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)storeIncome:(HttpRequestMethod)httpRequestMethod
                   url:(NSString *)url
                 param:(NSDictionary *)param
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock;

// 商品推荐
-(void)recommendGoods:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
            param:(NSDictionary *)param
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock;

// 删除商品推荐
-(void)deleteRecommendGoods:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock;
/**
 客户提现
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)userWithdraw:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;

/**
 收支明细
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)incomeDetails:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock;

/**
 收入详情
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)incomeDetailsMessage:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

/**
 拍卖详情
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)auctionDetailMessage:(HttpRequestMethod)httpRequestMethod
                        url:(NSString *)url
                      param:(NSDictionary *)param
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock;
/**
 热卖信息
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)homeHotSaleMessage:(HttpRequestMethod)httpRequestMethod
                        url:(NSString *)url
                      param:(NSDictionary *)param
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock;

/**
 用户信息详情
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)UserDetailsMessage:(HttpRequestMethod)httpRequestMethod
                        url:(NSString *)url
                      param:(NSDictionary *)param
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock;

/**
 卖家获取绑定的验证码
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)getSellerBindCode:(HttpRequestMethod)httpRequestMethod
                     url:(NSString *)url
                   param:(NSDictionary *)param
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;

/**
 *  拍卖状态
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
-(void)AuctionStatus:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               model:(NSString *)model
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;


/**
 *  拍卖参与
 *
 *  @param httpRequestMethod
 *  @param url
 *  @param param
 *  @param successBlock
 *  @param failureBlock
 */
-(void)AuctionJoin:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               model:(NSString *)model
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

/*
 获取客户列表信息
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)customTableMessage:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;

/*
 直播间获取商品详情
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)GoodsGet:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          model:(NSString *)model
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock;

/*
 直播间获取评论信息
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)GoodsCommentList:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          model:(NSString *)model
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock;

/*
 根据用户的BPOID获取简单信息
 @param httpRequestMethod
 @param url
 @param param
 @param successBlock
 @param failureBlock
 */
-(void)GetMemberByBPOID:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  model:(NSString *)model
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock;

// 店铺商品信息
- (void)GoodsInfo:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
               model:(NSString *)model
             success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock;

// 拍卖商品
- (void)auctionGoods:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
               model:(NSString *)model
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

// 开始直播
- (void)showStart:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
            param:(NSDictionary *)param
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock;


// 支付方式
- (void)Payment:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
               model:(NSString *)model
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

// 未支付修改运费和商品总金额
- (void)FixTranFee:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          param:(NSDictionary *)param
          model:(NSString *)model
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock;

//添加评论
-(void)addComment:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
            param:(NSDictionary *)param
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock;

// 查询评价个数
-(void)CommentNumber:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;

// 获取客户评价信息
-(void)CustomComment:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

// 物流
-(void)SendShopDetails:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

// 获取主播信息
- (void)getShowMemberInfo:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                    model:(NSString *)model
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock;
// 线下支付订单
- (void)offLinePay:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;

// 程序进入后台挂起直播
- (void)showPause:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;

// 普通支付
- (void)normalPay:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;

// 判断是否关注当前用户
- (void)checkStarStatus:(HttpRequestMethod)httpRequestMethod
              url:(NSString *)url
            param:(NSDictionary *)param
          success:(SuccessBlock)successBlock
          failure:(FailureBlock)failureBlock;

// 回复评论
-(void)ReplyComment:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;
// 打赏
- (void)rewardPerson:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock;

//一键购买
-(void)QuickBuy:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  model:(NSString *)model
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock;

//直播历史
-(void)PlayHistory:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          model:(NSString *)model
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock;

//获取店铺运费
-(void)GetStoreTranFee:(HttpRequestMethod)httpRequestMethod
                   url:(NSString *)url
                 model:(NSString *)model
                 param:(NSDictionary *)param
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock;


//根据用户的BPOID获取实体店信息
-(void)GetShopAuthentication:(HttpRequestMethod)httpRequestMethod
                   url:(NSString *)url
                 model:(NSString *)model
                 param:(NSDictionary *)param
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock;


//订单支付状态
-(void)OrderPayStatus:(HttpRequestMethod)httpRequestMethod
                         url:(NSString *)url
                       model:(NSString *)model
                       param:(NSDictionary *)param
                     success:(SuccessBlock)successBlock
                     failure:(FailureBlock)failureBlock;

//下载录音文件
-(void)downLoadVoice:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock;

//极光推送
-(void)uploadMessage:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock;

//提现提示信息
-(void)uploadPrompt:(HttpRequestMethod)httpRequestMethod
                 url:(NSString *)url
               param:(NSDictionary *)param
             success:(SuccessBlock)successBlock
             failure:(FailureBlock)failureBlock;

//订单充值
-(void)orderRecharge:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock;

//支付回调
-(void)applePayLoading:(HttpRequestMethod)httpRequestMethod
                        url:(NSString *)url
                      param:(NSDictionary *)param
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock;

//首页跳转
-(void)jumpHome:(HttpRequestMethod)httpRequestMethod
                   url:(NSString *)url
                 param:(NSDictionary *)param
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock;

//是否参与拍卖
-(void)isSaleNetwork:(HttpRequestMethod)httpRequestMethod
            url:(NSString *)url
          param:(NSDictionary *)param
        success:(SuccessBlock)successBlock
        failure:(FailureBlock)failureBlock;

//发送弹幕
-(void)sendBarrageMessage:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;
//用户中心(新)
-(void)personalCenter:(HttpRequestMethod)httpRequestMethod
                  url:(NSString *)url
                param:(NSDictionary *)param
              success:(SuccessBlock)successBlock
              failure:(FailureBlock)failureBlock;

//获取首页轮播
-(void)getScrollImage:(HttpRequestMethod)httpRequestMethod
                      url:(NSString *)url
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;

//分享前
-(void)shareWeChatBefore:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;

//分享后
-(void)shareWeChatAfter:(HttpRequestMethod)httpRequestMethod
               url:(NSString *)url
             param:(NSDictionary *)param
           success:(SuccessBlock)successBlock
           failure:(FailureBlock)failureBlock;

//用户日志
-(void)userAccount:(HttpRequestMethod)httpRequestMethod
                    url:(NSString *)url
                  param:(NSDictionary *)param
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock;

//群红包
-(void)LaunchFlockRedPacket:(HttpRequestMethod)httpRequestMethod
                        url:(NSString *)url
                      param:(NSDictionary *)param
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock;

//单人红包
-(void)LaunchOnceRedPacket:(HttpRequestMethod)httpRequestMethod
                        url:(NSString *)url
                      param:(NSDictionary *)param
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock;

//红包详情
-(void)RedPacketDetails:(HttpRequestMethod)httpRequestMethod
                       url:(NSString *)url
                     param:(NSDictionary *)param
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock;

-(void)RedBagConfig:(HttpRequestMethod)httpRequestMethod
                url:(NSString *)url
              param:(NSDictionary *)param
            success:(SuccessBlock)successBlock
            failure:(FailureBlock)failureBlock;

@end

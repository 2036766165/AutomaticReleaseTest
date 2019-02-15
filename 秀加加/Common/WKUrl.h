//
//  Header.h
//  秀加加
//
//  Created by sks on 2016/9/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#ifndef Header_h
#define Header_h

/*
 *获取验证码 1 登录 2 忘记密码 3 绑定手机
 */
#define WKGetAuthCode           @"Member/SendPhoneValidateCode"

/*
 *登录
 */
#define WKLoginByTel            @"Member/DoLoginForAppTel"

// 微信登录
#define WKMember_LoginWX        @"Member/DoLoginForAppWX"

//退出系统
#define WKAppLogOut             @"Member/AppLogOut"

// 商品列表
#define WKGoodsList             @"ShopGoods/GoodsListGet"

//店铺商品信息
#define WKGoodsInfo             @"ShopGoods/ShopGoodsInfo"

//关注端商品列表
#define WKLiveGoodsList         @"Goods/GoodsListGet"

// 获取个人信息
#define WKGetPersonMessage      @"Member/GetLoginMemberInfo"

//获取用户的统计信息
#define WKGetMemberMessageCount      @"Member/GetMemberRelationCount"

//店铺订单发货
#define WKStoreSendShop         @"Order/OrderDeliver"

//获取系统时间
#define WKGetSystemTime         @"Common/GetSystemDate"

// 上传图片
#define WKUploadImage           @"Common/UploadFile"

// 上传商品
#define WKAddGoods              @"ShopGoods/GoodsAdd"

//我的关注(关注)
#define WKAttention              @"Member/GetMemberFollow"

//我的关注(粉丝)
#define WKFans                   @"Member/GetMemberFuns"

//我的积分
#define WKMyIntegral             @"Member/GetMemberPointLogByPage"

//查询历史记录
#define WKSearchHistory          @"Member/GetMemberBroweHistory"

//我的订单查询
#define WKMyOrder                @"Order/OrderSearch"

//我的订单详情
#define WKMyOrderDetail         @"Order/OrderDetail"

//店铺订单查询
#define WKStoreOrder             @"Order/ShopOrderSearch"

//店铺订单删除
#define WKOrderRemove           @"Order/OrderDelete"

//店铺订单详情
#define WKOrderDetail           @"Order/ShopOrderDetail"

//店铺线下支付
#define WKOrderPayOffline       @"Order/OrderPayOffLine"

//店铺订单快递单号修改
#define WKOrderFixExpress       @"Order/OrderExpressCodeUpdate"

//个人订单删除
#define WKPersonOrderRemove     @"Order/OrderDelete"

//个人取消订单
#define WKPersonOrderCancel     @"Order/OrderCancel"

//获取融云token
#define WKGetRongToken          @"Member/GetRongCloudToken"

//获取关注,取消关注
#define WKFollow                @"Member/SetMemberFollow"

//获取通讯录
#define WKGetBook               @"Member/GetMemberContacts"

// 获取商品详情
#define WKGoodsDetail           @"ShopGoods/GoodsInfoGet"

// 直播间获取商品详情
#define WKLiveGoodsDetail           @"Goods/GoodsGet"

//直播间获取评论信息
#define WKLiveGoodsComment      @"Goods/GoodsCommentList"

// 更新商品
#define WKGoodsUpdate           @"ShopGoods/GoodsEdit"

// 商品批量下架
#define WKGoodsBatchDown        @"ShopGoods/GoodsBatchDown"

// 商品批量上架
#define WKGoodsBatchUp          @"ShopGoods/GoodsBatchUp"

// 商品置顶
#define WKGoodsTop              @"ShopGoods/GoodsToTop"

// 删除商品
#define WKGoodsDelete           @"ShopGoods/GoodsDelete"

// 修改个人信息
#define WKMemberUpdateInfo      @"Member/ModifyMemberInfo"

//支付方式
#define WKPayUrl               @"Order/Payment"

//一键购买
#define WKQuickBuy              @"Order/QuickBuy"

// 获取标签
#define WKGetTag                @"Common/GetTag"

// 获取地址列表
#define WKAddresssList          @"Member/GetAllMemberAddress"

// 添加新地址
#define WKAddressAdd            @"Member/AddMemberAddress"

// 修改用户地址
#define WKAddressUpdate         @"Member/ModifyMemberAddress"

// 删除用户地址
#define WKAddressDelete         @"Member/DeleteMemberAddress"

// 设置默认用户地址
#define WKAddressSetDefault     @"Member/MemberAddressSetDefault"

// 获取用户地址详情
#define WKAddressDetail         @"Member/GetMemberAddressByID"

// 首页热门信息
#define WKHomeHotMessage        @"Member/GetMemberLive"

// 个人信息评价晒单e
#define WKEvaluateTable         @"Order/OrderCommentList"

// 提交店铺消息
#define WKMemberAuth            @"Member/ApplyShopAuthentication"

// 获取店铺认证消息
#define WKMemberAuthInfo        @"Member/GetShopAuthenticationInfo"
// 根据用户的BPOID获取实体店信息
#define WKMemberAuthInfoByID    @"Member/GetShopAuthenticationInfoByID"

// 处罚申诉
#define WKCommonPunish          @"Common/AddComplain"

// 商品推荐
#define WKGoodsRecomend         @"ShopGoods/RecommendAdd"

// 取消商品推荐
#define WKGoodsDeleteRecommend  @"ShopGoods/RecommendRemove"

// 用户收入/余额
#define WKStoreIncome           @"Member/GetMemberIncome"

//获取卖家提现验证的验证码
#define WKSellerBind            @"Member/GetBindOpenIDCode"

// 用户提现
#define WKUserWithdraw          @"Member/ApplyBankMoney"

// 收支明细
#define WKIncomeDetailsUrl      @"Member/GetMemberAccountLogByPage"

// 提现详情
#define WKWithdrawDetailsUrl    @"Member/GetMemberWithdrawInfo"

// 拍卖订单详情
//#define WKAuctionDetailsUrl     @"Order/OrderDetail"

// 热卖
#define WKHotSaleMessage        @"Goods/HotGoodsSelect"

// 用户信息详情
#define WKUserMessageDetails    @"Member/GetMemberDetail"

//拍卖状态 / 筹卖状态
#define WKAuctionStatus         @"Order/SpecialSaleStatus"

//拍卖参与
#define WKAuctionJoin           @"Order/SpecialSaleJoin"

// 客户列表
#define WKCustomTableMessage    @"Member/GetMemberCustomerByPage"

// 拍卖商品
#define WKOrderAuction           @"Order/AuctionStart"

// 拍卖/筹卖
#define WKSpecialSale            @"Order/SpecialSaleStart"
// 查询拍卖状态
#define WKOrderAuctionStatus    @"Order/AuctionStatus"

//未支付修改运费
#define WKFixTranFee            @"Order/OrderInfoUpdate"

//添加评论
#define WKAddComment            @"Goods/CommentAdd"

// 开始直播
#define WKMemberShowStart       @"Member/ModifyMemberRelationCount"

// 上传横竖屏
#define WKMemberShowStatus      @"Member/ModifyRelationCountForLiveStart"

//根据用户的BPOID 获取简单信息
#define WKGetMemberByBPOID      @"Member/GetMemberByBPOID"

// 客户评论个数
#define WKCommentNumber         @"ShopGoods/GetCommentCount"

// 客户评论详情
#define WKCustomComment         @"ShopGoods/GoodsCommentList"

// 物流
#define WKSendShopDetails       @"Order/OrderExpressDetail"

// 获取店主信息
#define WKMemberGetShowInfo     @"Member/GetLoginMemberInfoByMemberNo"

// 直播是挂起
#define WKShowPause             @"LiveRoom/VideoPause"

// 播放时挂起
#define WKPlayPause             @"LiveRoom/VideoPlay"

// 判断是否关注当前用户
#define WKMemberCheckStar       @"Member/CheckFollowStatus"

// 回复评论
#define WKReplyComment          @"ShopGoods/GoodsCommentReply"
// 打赏用户
#define WKOrderRewardPerson          @"Order/RewardSubmit"

//添加用户直播历史
#define WKPlayHistory           @"Member/AddMemberBrowseHistory"

//获取店铺运费
#define WKGetStoreTranFee       @"Member/GetShopTranFee"

//获取用户的BPOID实体店信息
#define WKGetShopAuthentication @"Member/GetShopAuthenticationInfoByBPOID"

#define WKUploadCityName        @"Member/ModifyMemberRelationCount"

//订单支付状态
#define WKOrderPayStatus        @"Order/OrderPayStatus"

//极光推送
#define WKUploadPush            @"Member/SetRegistrationID"

// 获取推流地址
#define WKGetPushURL            @"LiveRoom/GetPushUrl"

// 是否显示打赏
#define WKShowReward            @"Common/IsReward"

// 获取打赏消息
#define WKRewardInfo            @"Common/GetRewardConfig"

// 直播间解禁言
#define WKRoomStartTalk         @"LiveRoom/RoomStartTalk"

// 直播间禁言
#define WKRoomStopTalk          @"LiveRoom/RoomStopTalk"

// 记录登录日志
#define WKLoginLog              @"Member/AddMemberLoginLog"

// 获取关注用户列表
#define WKAttentionList         @"Member/GetMemberAcceptInfo"

// 总通知开关
#define WKSetFocusStatus        @"Member/SetLiveNotificationStatus"

// 个人通知开关
#define WKSingleFocus           @"Member/SetMemberLiveAcceptStatus"

// 提现提示信息
#define promptMessage           @"Member/GetWithdrawConfig"

// 充值订单
#define rechargeOrder           @"Order/RechargeSubmit"

// 支付回调
#define applePay                @"Order/Payment"

// 首页跳转
#define homeJump                @"Member/OfficialActivity"

// 是否参与拍卖
#define isSale                  @"Order/AuctionIsJoin"

// 发送弹幕
#define sendBarrage             @"Order/SendBarrageMessage"

// 用户中心
#define personalCenterUrl       @"/Member/GetMemberCenterInfo"

// 获得首页轮播图
#define GetScrollImage          @"Member/GetScrollImage"

// 排行榜
#define WKRankList              @"Order/RankList"

// 虚拟世界
#define WKVirtualList           @"Order/VirtualWorld"

// 删除虚拟世界
#define WKDeleteVirtual         @"Order/VirtualWorldDelete"

// join list
#define WKJoinList              @"Order/SpecialSaleJoinList"

// 分享前
#define WKShareBefore           @"Common/ShareConfig"

// 分享后
#define WKShareAfter            @"Common/ShareRoom"

// confirm address
#define WKConfirmAddress        @"Order/OrderAddressConfirm"

// online list
#define WKOnlineList            @"LiveRoom/GetOnlineMembers"

// add advice
#define WKAddAdvice             @"Common/AddAdvice"

// room activity
#define WKRoomActivity          @"Common/RoomActivity"
// 群红包
#define WKFlockRedPacket        @"Member/SendRedBagToGroup"

// 单人红包
#define WKOnceRedPacket         @"Member/SendRedBagToMember"

// 红包详情
#define WKRedPacketDetailsUrl      @"Member/GetRedBagInfo"

// 抢群红包
 #define WKGrabRedPacket         @"Member/RobRedBagFromGroup"

// 查看红包状态
#define WKCheckRedPacket        @"Member/CheckRedBagStatus"

// 获取红包配置信息
#define WKGetRedBagConfig       @"Member/GetRedBagConfig"

#endif /* Header_h */

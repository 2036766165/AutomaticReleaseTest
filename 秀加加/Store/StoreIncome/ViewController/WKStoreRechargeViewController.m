//
//  WKStoreRechargeViewController.m
//  秀加加
//
//  Created by Chang_Mac on 16/12/14.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreRechargeViewController.h"
#import "WKStoreRechargeView.h"
#import "UIBarButtonItem+Extension.h"
//#import <StoreKit/StoreKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "NSObject+XWAdd.h"
#import "WKPayTool.h"
@interface WKStoreRechargeViewController (){
//<SKPaymentTransactionObserver, SKProductsRequestDelegate>{
    WKStoreRechargeView *_storeView;
}
//@property (strong, nonatomic) SKPayment *payment;
//@property (strong, nonatomic) SKMutablePayment *g_payment;
@property (strong, nonatomic) NSString * insideBuy;
@property (strong, nonatomic) WKStoreRechargeView *storeView;
@property (assign, nonatomic) BOOL isPay;//控制是否支付中
@end

@implementation WKStoreRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMainUI];
}

-(void)createMainUI{

    [self getMemberIncome];
    WKStoreRechargeView *storeView = [[WKStoreRechargeView alloc]initWithFrame:self.view.bounds];
    _storeView = storeView;
    storeView.block = ^(NSString * rechargeID){
        NSString *str = [rechargeID substringWithRange:NSMakeRange(rechargeID.length-1, 1)];
        NSString *money = [rechargeID substringToIndex:rechargeID.length-1];
        if ([str isEqualToString:@"w"]) {//微信支付
            [self rechargePay:money andPayWay:@"2"];
        }else{//支付宝
            [self rechargePay:money andPayWay:@"4"];
        }
    };
    [self.view addSubview:storeView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW/2-20, 20, 40, 44)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"充值";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 44)];
    [backBtn setImage:[UIImage imageNamed:@"baijiantou"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //注册键盘出现的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%f",SCREEN_HEIGHT - 612);
    CGFloat a = SCREEN_HEIGHT-  (self.storeView.backView.frame.origin.y+self.storeView.backView.frame.size.height);
    CGFloat bottom = keyBoardFrame.size.height - a ;
    CGRect rect = self.view.bounds;
    rect.origin.y = -bottom;
    self.storeView.frame = rect;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.storeView.frame = self.view.bounds;
}

-(void)payData:(NSString *)orderCode
       PayType:(NSInteger)PayType
     orderType:(NSInteger)orderType
     addressId:(NSString *)addressId
{
    NSDictionary *param = @{@"OrderCode":orderCode,
                            @"PayType":@(PayType),
                            @"OrderType":@(orderType),
                            @"AddressID":addressId};
    
    NSLog(@"%@",param);
    
    [[WKPayTool shareInstance] payWith:param type:PayType completionBlock:^(id obj) {
        WKPayResult *payResult = obj;
        if(payResult.resultType == WKPayResultTypeSuccess)
        {
            [self xw_postNotificationWithName:@"RECHARGESUCCESS" userInfo:@{}];
            [self back];
        }
    }];
}
-(void)rechargePay:(NSString *)money andPayWay:(NSString *)payWay{
    [WKHttpRequest orderRecharge:HttpRequestMethodPost url:rechargeOrder param:@{@"PayAmount":money,@"PayType":payWay,@"OrderFrom":@"3"} success:^(WKBaseResponse *response) {
        [self payData:response.Data PayType:[payWay integerValue] orderType:5 addressId:@""];
    } failure:^(WKBaseResponse *response) {
        
    }];
}
- (void)back {
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
        if(self.block) {
            self.block();
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

#pragma mark 内购

//-(void)appleInsideBuy{
//    [MBProgressHUD showHUDAddedTo: _storeView animated:YES];
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    if ([SKPaymentQueue canMakePayments]) {
//        [self requestProductData:self.insideBuy];
//    } else {
//        NSLog(@"不允许程序内付费");
//    }
//}
//- (void)requestProductData:(NSString *)type {
//    //根据商品ID查找商品信息
//    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
//    NSSet *nsset = [NSSet setWithArray:product];
//    //创建SKProductsRequest对象，用想要出售的商品的标识来初始化， 然后附加上对应的委托对象。
//    //该请求的响应包含了可用商品的本地化信息。
//    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
//    request.delegate = self;
//    [request start];
//}
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
//    //接收商品信息
//    NSArray *product = response.products;
//    if ([product count] == 0) {
//        return;
//    }
//    // SKProduct对象包含了在App Store上注册的商品的本地化信息。
//    SKProduct *storeProduct = nil;
//    for (SKProduct *pro in product) {
//        if ([pro.productIdentifier isEqualToString:self.insideBuy]) {
//            storeProduct = pro;
//        }
//    }
//    //创建一个支付对象，并放到队列中
//    self.g_payment = [SKMutablePayment paymentWithProduct:storeProduct];
//    //设置购买的数量
//    self.g_payment.quantity = 1;
//    [[SKPaymentQueue defaultQueue] addPayment:self.g_payment];
//}
//- (void)requestProUpgradeProductData
//{
//    NSLog(@"------请求升级数据---------");
//    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
//    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
//    productsRequest.delegate = self;
//    [productsRequest start];
//    
//}
////弹出错误信息
//- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
//    NSLog(@"-------弹出错误信息----------");
//    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
//                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
//    [alerView show];
//    
//}
//
//-(void) requestDidFinish:(SKRequest *)request
//{
//    NSLog(@"----------反馈信息结束--------------");
//    
//}
//
//-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
//    NSLog(@"-----PurchasedTransaction----");
//    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
//    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
//}
////监听购买结果
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
//    for (SKPaymentTransaction *tran in transaction) {
//        // 如果小票状态是购买完成
//        if (SKPaymentTransactionStatePurchased == tran.transactionState) {
//            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
//            // 更新界面或者数据，把用户购买得商品交给用户
//            //返回购买的商品信息
//            [MBProgressHUD hideHUDForView:_storeView animated:NO];
//            [self back];
//            [self verifyPruchase];
//            //商品购买成功可调用本地接口
//        } else if (SKPaymentTransactionStateRestored == tran.transactionState) {
//            // 将交易从交易队列中删除,恢复已购
//            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
//        } else if (SKPaymentTransactionStateFailed == tran.transactionState) {
//            // 支付失败
//            // 将交易从交易队列中删除
//            [MBProgressHUD hideHUDForView:_storeView animated:NO];
//            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
//        }
//    }
//}
////交易结束
//- (void)completeTransaction:(SKPaymentTransaction *)transaction {
//    NSLog(@"交易结束");
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//}
//
//#pragma mark 验证购买凭据
//- (void)verifyPruchase {
//    // 验证凭据，获取到苹果返回的交易凭据
//    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
//    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
//    // 从沙盒中获取到购买凭据
//    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
//    // 发送网络POST请求，对购买凭据进行验证
//    //测试验证地址:https://sandbox.itunes.apple.com/verifyReceipt
//    //正式验证地址:https://buy.itunes.apple.com/verifyReceipt
//    NSURL *url = [NSURL URLWithString:ItunesVerify];
//    NSMutableURLRequest *urlRequest =
//    [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
//    urlRequest.HTTPMethod = @"POST";
//    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
//    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
//    urlRequest.HTTPBody = payloadData;
//    // 提交验证请求，并获得官方的验证JSON结果 iOS9后更改了另外的一个方法
//    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
//    // 官方验证结果为空
//    if (result == nil) {
//        NSLog(@"验证失败");
//        return;
//    }
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//    if (dict != nil) {
//        // 比对字典中以下信息基本上可以保证数据安全
//        // bundle_id , application_version , product_id , transaction_id
////        NSLog(@"验证成功！购买的商品是：%@", @"_productName");
//        [self uploadDataToServer:encodeStr];
//    }
//}
//#pragma mark 服务器验证
//-(void)uploadDataToServer:(NSString *)dataStr{
//    if (self.isPay) {
//        return;
//    }
//    self.isPay = YES;
//    NSString *money = @[@"4.2",@"20.58",@"41.16",@"",@"67.24"][[self.insideBuy integerValue]-10001];
//    [WKHttpRequest orderRecharge:HttpRequestMethodPost url:rechargeOrder param:@{@"PayAmount":money,@"PayType":@"7",@"OrderFrom":@"3"} success:^(WKBaseResponse *response) {
//        
//        [WKHttpRequest Payment:HttpRequestMethodPost url:applePay param:@{@"OrderCode":response.Data,@"PayType":@"7",@"OrderType":@"5",@"AddressID":dataStr} model:nil success:^(WKBaseResponse *response) {
//            NSLog(@"服务器验证成功");
//            [self getMemberIncome];
//             [self xw_postNotificationWithName:@"rechargeNumber" userInfo:nil];
//        } failure:^(WKBaseResponse *response) {
//            NSLog(@"服务器验证失败");
//        }];
//    } failure:^(WKBaseResponse *response) {
//        
//    }];
//}
//     
//// 获取用户余额
- (void)getMemberIncome{
    
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKStoreIncome param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response : %@",response);
        
        [_storeView refreshBalanceMoney:[NSString stringWithFormat:@"%@",response.Data[@"MoneyCanTake"]]];        
    } failure:^(WKBaseResponse *response) {
        
    }];
}
//
//-(void)dealloc{
//    self.isPay = NO;
//}

@end

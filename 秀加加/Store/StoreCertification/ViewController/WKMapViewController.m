//
//  ViewController.m
//  原生地图
//
//  Created by sks on 16/8/30.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "WKMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "WKTextField.h"
#import "WKSearchTableViewCell.h"

static NSString *cellId = @"cellId";

@interface WKMapViewController () <MKMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    WKGetLocation *_location;
    MKMapView *_mapView;
    WKAnnotationTest *_annotation;
    
    UITableView *_searchTable;
    NSMutableArray *_locationsArr;
    NSString *_searchText;
    
}

@property (nonatomic,strong) MKLocalSearch *search;
@property (nonatomic,strong) MKLocalSearchRequest *searchRequest;
@property (nonatomic,assign) NSInteger searchView;

@end

@implementation WKMapViewController

- (instancetype)initWith:(NSInteger)search
{
    if(self = [super init])
    {
        _searchView = search;
    }
    return self;
}

-(void)setAddressModel:(WKGetShopAuthenticationModel *)addressModel
{
    _addressModel = addressModel;
}

- (MKLocalSearchRequest *)searchRequest{
    if (!_searchRequest) {
        _searchRequest = [[MKLocalSearchRequest alloc] init];
    }
    return _searchRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationsArr = @[].mutableCopy;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    [self.view addSubview:_mapView];
    
    if (_searchView == 0) {
        self.title = @"定位地址";

        _mapView.userTrackingMode = MKUserTrackingModeFollow;

        WKTextField *searchText = [[WKTextField alloc] initWithFrame:CGRectMake(0, 0, WKScreenW - 100, 30)];
        searchText.placeholder = @"搜索地理位置";
        searchText.layer.borderWidth = 0.6;
        searchText.layer.borderColor = [UIColor lightGrayColor].CGColor;
        searchText.layer.cornerRadius = 15;
        [searchText addTarget:self action:@selector(searchWith:) forControlEvents:UIControlEventEditingChanged];
        
        self.navigationItem.titleView = searchText;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(searchResult:)];

        _location = [[WKGetLocation alloc] init];
        
        [_location getLocationCompletion:^(WKAnnotationTest *annotation) {
            [_mapView addAnnotation:annotation];
            _annotation = annotation;
            [_mapView selectAnnotation:annotation animated:YES];
        }];
        
        _searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 0) style:UITableViewStyleGrouped];
        _searchTable.delegate = self;
        _searchTable.dataSource = self;
        [self.view addSubview:_searchTable];
        
        _searchTable.loading = YES;
        _searchTable.loading = NO;
        _searchTable.buttonText = @"未搜索到位置";
        _searchTable.descriptionText = @"";
        _searchTable.buttonNormalColor = [UIColor lightGrayColor];
        
    }else{
        // 反地理编码显示店铺地址
        
        self.title = @"店铺地址";
        
//        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = MKUserTrackingModeNone;

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiBack)];
        
        WKAnnotationTest *ann = [[WKAnnotationTest alloc] init];
        CLLocationCoordinate2D point = CLLocationCoordinate2DMake(_addressModel.ShopLat.doubleValue, _addressModel.ShopLong.doubleValue);
        ann.coordinate = point;
        ann.title = [NSString stringWithFormat:@"%@%@%@",_addressModel.ProvinceName,_addressModel.CityName,_addressModel.CountyName];
        ann.subtitle = _addressModel.ShopAddress;
        
        [_mapView addAnnotation:ann];
        
        _annotation = ann;
        [_mapView selectAnnotation:ann animated:YES];

        [_mapView setCenterCoordinate:_annotation.coordinate animated:YES];
        
        MKCoordinateRegion region;
        region.span.latitudeDelta = 0.05;
        region.span.longitudeDelta = 0.05;
        region.center = _annotation.coordinate;
        // 设置显示位置(动画)
        [_mapView setRegion:region animated:YES];
        // 设置地图显示的类型及根据范围进行显示
        [_mapView regionThatFits:region];
    }
    
}

- (void)bbiBack{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        _searchTable.frame = CGRectMake(0, 64, WKScreenW, WKScreenH - height - 44);
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.3 animations:^{
        _searchTable.frame = CGRectMake(0, 0, WKScreenW, 0);
    }];

}

//MARK: 搜索结果
- (void)searchResult:(UIBarButtonItem *)item{
    
    if (self.locationBlock) {
        self.locationBlock(_annotation);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)searchWith:(UITextField *)textfiled{
    // POI 检索
    if (textfiled.text.length == 0) {
        [_locationsArr removeAllObjects];
        [_searchTable reloadData];
        return;
    }
   MKCoordinateRegion region = MKCoordinateRegionMake(_mapView.centerCoordinate, MKCoordinateSpanMake(0.02, 0.02));
    self.searchRequest.region = region;
    self.searchRequest.naturalLanguageQuery = textfiled.text;
    
    self.search = [[MKLocalSearch alloc] initWithRequest:self.searchRequest];

    [self.search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        
         _locationsArr = [NSMutableArray arrayWithArray:response.mapItems];
           if ([_locationsArr count ] > 0) {
            //移除目前地图上得所有标注点
              [_mapView removeAnnotations:_mapView.annotations];
            
            }
            for (int i=0; i<_locationsArr.count; i++) {
            MKMapItem * mapItem=_locationsArr[i];
            NSDictionary *addressDict = mapItem.placemark.addressDictionary;
            
            WKAnnotationTest *annotation = [[WKAnnotationTest alloc] init];
            annotation.title = @"您的位置是";
            annotation.subtitle = [NSString stringWithFormat:@"%@",mapItem.placemark.name];
            annotation.coordinate = mapItem.placemark.location.coordinate;
            annotation.city = addressDict[@"City"];
            annotation.country = addressDict[@"SubLocality"];
            annotation.province = addressDict[@"State"];
            
            annotation.street = addressDict[@"Street"];
            
            _annotation = annotation;
              
            [_mapView addAnnotation:annotation];
              if (i == 0) {
                  [_mapView selectAnnotation:_annotation animated:YES];
              }
        }
        [_searchTable reloadData];

    }];
    [_searchTable resignFirstResponder];
  

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _locationsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WKSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    MKMapItem *item = _locationsArr[indexPath.row];
    [cell setModel:item searchText:_searchText];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKMapItem *item = _locationsArr[indexPath.row];
    
    NSDictionary *addressDict = item.placemark.addressDictionary;
    
    WKAnnotationTest *annotation = [[WKAnnotationTest alloc] init];
    annotation.title = @"您的位置是";
    annotation.subtitle = [NSString stringWithFormat:@"%@",item.placemark.name];
    annotation.coordinate = item.placemark.location.coordinate;
    annotation.city = addressDict[@"City"];
    annotation.country = addressDict[@"SubLocality"];
    annotation.province = addressDict[@"State"];
    
    annotation.street = addressDict[@"Street"];
    
    _annotation = annotation;
    
    if (self.locationBlock) {
        self.locationBlock(_annotation);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - MapView Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    mapView.showsUserLocation = NO;
//    [_mapView setCenterCoordinate:_annotation.coordinate animated:YES];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *ID = @"annotation";
    // MKAnnotationView 默认没有界面  可以显示图片
    // MKPinAnnotationView有界面      默认不能显示图片
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        //设置大头针颜色
        annotationView.pinTintColor = [UIColor colorWithRed:0.13 green:0.81 blue:0.63 alpha:1.00];
        //设置为动画掉落的效果
        annotationView.animatesDrop = YES;
        //显示详情
        annotationView.canShowCallout = YES;
    }
    
    annotationView.annotation = annotation;
    
    
//    [annotationView setSelected:YES];

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"选择了colloutView");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    CLLocationCoordinate2D cooridnate = [_mapView convertPoint:point toCoordinateFromView:self.view];
    
    NSLog(@"annotation log  %f lat %f",cooridnate.latitude,cooridnate.longitude);
    
    [_location getAnnotationWith:cooridnate completion:^(WKAnnotationTest *annotation) {
        
        NSLog(@"annotation log  %f lat %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
        WKAnnotationTest *an = [_mapView.annotations firstObject];
        an.title = annotation.title;
        an.subtitle = annotation.subtitle;
        an.coordinate = annotation.coordinate;
        [_mapView selectAnnotation:an animated:YES];
        
        _annotation = annotation;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

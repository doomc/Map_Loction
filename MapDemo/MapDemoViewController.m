//
//  MapDemoViewController.m
//  MapDemo
//
//  Created by 熊维东 on 16/5/31.
//  Copyright © 2016年 熊维东. All rights reserved.
//

#import "MapDemoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "KKAnnotation.h"


@interface MapDemoViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate>
{
    CLLocationManager * _locationManager;
    CLGeocoder * _geocoder; //地理编码
    MKMapView * _mapView;
    CLLocationDegrees   _longitude  ;//经度
    CLLocationDegrees   _latitude; //纬度
   
    CLLocation * _currentLocation;//当前位置
    
    
}

@property (weak, nonatomic) IBOutlet UITextField *SearchTextFld;
@property (weak, nonatomic) IBOutlet UILabel *longAndW;
@property (weak, nonatomic) IBOutlet UILabel *city_name;

@property (weak, nonatomic) IBOutlet UIView *map_View;


@end

@implementation MapDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _locationManager = [[CLLocationManager alloc]init];
    _geocoder = [[CLGeocoder alloc]init];

    self.SearchTextFld.delegate=  self;
    
    [self initCoreLoaction];
    
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.SearchTextFld.text = textField.text;
    
}

-(void)initCoreLoaction
{
    if (![CLLocationManager locationServicesEnabled]) {
        
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        
        return;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        [_locationManager requestWhenInUseAuthorization];
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        _locationManager.delegate =self;
        //精度越精确越耗电
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10000.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        
        [_locationManager startUpdatingLocation];
        
        
    }
    

}

//coreloaction delegate
 #pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    _currentLocation = [locations firstObject];//取出数组中第一个位置
    CLLocationCoordinate2D coordinate  = _currentLocation.coordinate;//位置坐标
  
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,_currentLocation.altitude,_currentLocation.course,_currentLocation.speed);
    _longAndW.text = [NSString stringWithFormat:@"经度%.2f,纬度%.2f 海拔：%.2f,",coordinate.longitude,coordinate.latitude,_currentLocation.altitude];
 
    _longitude  =  coordinate.longitude ;
    _latitude =   coordinate.latitude ;
    
    [self initGui];
    
    [self reverseGeocoder:_currentLocation];
    [_locationManager stopUpdatingLocation];

 
}
#pragma mark Geocoder
#pragma  marK  地理编码CLGeocoder类用于处理地理编码和逆地理编码（又叫反地理编码）功能。

//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
     [_geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);
        }else{
            
            CLPlacemark* placemark = placemarks.firstObject;
           
            NSLog(@"   地址 = %@ , 附近=%@ ，城市 = %@  ",  placemark.name,placemark.subLocality ,placemark.locality);
            
            
          
            _city_name.text = placemark.name;
            
            
        }
    }];
    
    [_locationManager stopUpdatingLocation];
    

}

//定位完成后 停止定位
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@" error = ===  %@ ",error);
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-(void)initGui
{
    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect]; 
    _mapView.delegate = self;
    [_mapView setShowsUserLocation:YES];
    [self.map_View addSubview:_mapView];

    
     //请求定位服务
    if (![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse   ) {
        
        [_locationManager requestWhenInUseAuthorization];
        
    }
    //用户追踪
    _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    
    //地图类型
    _mapView.mapType = MKMapTypeStandard;
    
    //添加大头针
    [self addanotation];
    
}
-(void)addanotation
{
  
   // CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(29.54, 116.35);
    CLLocationCoordinate2D location1 =CLLocationCoordinate2DMake(_latitude, _longitude-0.0001);
    
    
    KKAnnotation  *annotation1=[[KKAnnotation alloc]init];

    annotation1.title=@"我在这里~";
    annotation1.subtitle=@"我在长江里抓海鲜哦~";
    annotation1.coordinate= location1;
     annotation1.image = [UIImage imageNamed:@"Icon-Small"];
    
    [_mapView addAnnotation:annotation1];
    
    
   // CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(29.54, 116.35);

    CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(_latitude - 0.01,_longitude);
    KKAnnotation *annotation2=[[KKAnnotation alloc]init];
    annotation2.title=@"咖啡厅位置";
    annotation2.subtitle=@"某某街道";
    annotation2.coordinate=location2;
     annotation2.image = [UIImage imageNamed:@"Icon-Small"];

    [_mapView addAnnotation:annotation2];
}

#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"userLocation  == === %@",userLocation);
    // _mapView.centerCoordinate = userLocation.location.coordinate;

    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
        MKCoordinateSpan span=MKCoordinateSpanMake(0.01  , 0.01);
        MKCoordinateRegion region=MKCoordinateRegionMake(_currentLocation.coordinate, span);
        [_mapView setRegion:region animated:true];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
//    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
//    if ([annotation isKindOfClass:[KKAnnotation class]]) {
//        static NSString *key1=@"AnnotationKey1";
//        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
//        //如果缓存池中不存在则新建
//        if (!annotationView) {
//            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
//            annotationView.canShowCallout=true;//允许交互点击
//            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
//            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Icon-Small"]];//定义详情左侧视图
//        }
//        
//        //修改大头针视图
//        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
//        annotationView.annotation=annotation;
//        annotationView.image=((KKAnnotation *)annotation).image;//设置大头针视图的图片
//        
//        return annotationView;
//    }else {
//        return nil;
//    }
    
    // 获得地图标注对象
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN_ANNOTATION"];
    }
    // 设置大头针标注视图为紫色
    annotationView.pinColor = MKPinAnnotationColorPurple ;
    // 标注地图时 是否以动画的效果形式显示在地图上
    annotationView.animatesDrop = YES ;
    // 用于标注点上的一些附加信息
    annotationView.canShowCallout = YES ;
    
    return annotationView;

}
- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView withError:(NSError *)error {
    NSLog(@"error : %@",[error description]);
}


- (IBAction)searchaBt:(id)sender {
    NSLog(@"searching ~~~") ;
    if (_SearchTextFld.text == nil || [_SearchTextFld.text length]== 0) {
        return;
    }
    
[_geocoder geocodeAddressString:_SearchTextFld.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
    
    NSLog(@"查询记录 : %lu ",[placemarks count]);
    
    if ([placemarks count] >0) {
        //移除地图上所有标注的点
        [_mapView removeAnnotations:_mapView.annotations];
       
        
        
    }
    for (int  i = 0 ; i< [placemarks count]; i++) {
        CLPlacemark  * placemark =  placemarks[i];
        NSLog(@" placemark name ==== %@ " , placemark.name);
        
    }
        CLPlacemark  * placemark =   [placemarks objectAtIndex:0]; //placemarks[i];
       
        //关闭键盘
        [_SearchTextFld resignFirstResponder];
        
         //调整地图位置和缩放比例,第一个参数是目标区域的中心点，第二个参数：目标区域南北的跨度，第三个数：目标区域的东西跨度，单位都是米
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 200, 200);
        
        //重设地图试图的显示区域
        [_mapView setRegion:viewRegion  animated:YES];
        
        //实例化 KKAnnotation对象
         KKAnnotation * anntation = [[KKAnnotation alloc]init];
        anntation.coordinate = placemark.location.coordinate;
        anntation.city = placemark.name;
        
        _longAndW.text = [NSString stringWithFormat:@"经度：%.2f  纬度：%.2f 海拔：%.2f",anntation.coordinate.longitude ,anntation.coordinate.latitude,_currentLocation.altitude ];
        
        _city_name.text = [NSString stringWithFormat:@"%@",anntation.city];
        
        
        NSLog(@" 城市 ===  %@",anntation.city);
        
        
        
        // //把标注点MapLocation 对象添加到地图视图上，一旦该方法被调用，地图视图委托方法mapView：ViewForAnnotation:就会被回调
        [_mapView addAnnotation:anntation];
        
  //  }
  
}];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

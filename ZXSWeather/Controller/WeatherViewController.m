//
//  WeatherViewController.m
//  GodBlanket
//

#import "WeatherViewController.h"
#import "CollectionViewCell.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
#import "WeatherCityViewController.h"
#import "Single.h"
#import <CoreLocation/CoreLocation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#define kWidth CGRectGetWidth(self.view.bounds)
#define kHeight CGRectGetHeight(self.view.bounds)
#define kBarWidth (CGRectGetWidth(self.view.bounds)-16)/7
#define kBarHeight CGRectGetWidth(self.view.bounds)/6.25

@interface WeatherViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>
@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)UIView *barView;
@property(assign,nonatomic)NSInteger buttonY;
@property(assign,nonatomic)NSInteger viewTag;
@property(strong,nonatomic)UIButton *button;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)NSMutableArray *colorArray;
@property(strong,nonatomic)NSString *city;

//定位
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(strong,nonatomic)UILabel *cityLable;
@end



@implementation WeatherViewController
//懒加载
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)colorArray
{
    if (_colorArray == nil) {
        self.colorArray=[NSMutableArray array];
    }
    return  _colorArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    Single *s=[Single shareSingle];
    
    if (s.aString != nil) {
        [self z_makeData:s.aString];
    }else{
        [self z_makeData:self.city];
    }
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //关闭系统自动下移64单位
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.buttonY=(CGRectGetWidth(self.view.frame)/19.7368);
    //创建UICollectionViewFlowLayout
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(self.view.frame.size.width-30, self.view.frame.size.height-190);
    
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing=30;
    layout.minimumInteritemSpacing=30;
    layout.sectionInset=UIEdgeInsetsMake(40, 15, 130, 15);
    //初始化collectionView
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithHue:arc4random()%255/256.0 saturation:0.7 brightness:0.8 alpha:0.7];
    self.collectionView.pagingEnabled=YES;
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    [self.view addSubview:self.collectionView];
    //注册cell
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self z_barViews];
    
    self.navigationItem.title = @"天气";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"weatherCity.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightButtonAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    //定位
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
     [self initializeLocationService];
    [self start];
}
#pragma mark -------定位-----
- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    [_locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用。
    [_locationManager startUpdatingLocation];
}
#pragma mark----定位方法-------
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //将经度显示到label上
//    self.longitude.text = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    //将纬度现实到label上
//    self.latitude.text = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
           // self.location.text = placemark.name;
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
           // _cityLable.text = city;
            self.city=city;
            Single *s=[Single shareSingle];
            
            if (s.aString != nil) {
                [self z_makeData:s.aString];
            }else{
                [self z_makeData:self.city];
            }

            //self.navigationController.title=city;
          //  [_cityButton setTitle:city forState:UIControlStateNormal];
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
- (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}
#pragma mark-----判断联网--------
-(void) start {
    if (![self connectedToNetwork]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络连接错误" message:@"你需要连接到互联网使用此功能" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
           exit(0);
        }];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    } else {
        
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:nil
//                              message:@"Network Connection success"
//                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
    }
}

-(void)rightButtonAction
{
    WeatherCityViewController *cityVC=[[WeatherCityViewController alloc]init];
    if (self.city == nil) {
        self.city = @"北京";
    }
    cityVC.localCity = self.city;
    [self.navigationController showViewController:cityVC sender:nil];
}
#pragma mark---------makeData--------
-(void)z_makeData:(NSString *)sender
{
    self.dataArray = nil;
    if (sender == nil) {
        self.navigationItem.title = [NSString stringWithFormat:@"天气(定位中)"];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"天气(%@)", sender];
    }

    NSString *city=[sender stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSLog(@"%@", city);
    NSString *httpUrl = @"http://apis.baidu.com/showapi_open_bus/weather_showapi/address";
    NSString *httpArg =[NSString stringWithFormat:@"area=%@&needMoreDay=1&needIndex=0&needAlarm=0&need3HourForcast=0",city];

    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"f39412a48a76fa3638be966ecfc34238"forHTTPHeaderField: @"apikey"];
    NSURLSessionDataTask *task=[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //****data 不为 nil*****
        if (data != nil) {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            NSDictionary *dict=dic[@"showapi_res_body"];
          
            //把对象循环加入数组
            for (int i = 1; i < 8; i++) {
                NSString *str = [NSString stringWithFormat:@"f%d", i];
                NSDictionary *dict1 = dict[str];
                Model * model = [[Model alloc] init];
                [model setValuesForKeysWithDictionary:dict1];
                [self.dataArray addObject:model];
            }
                        //进入主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //开始时调用点击方法给第一个按钮赋值
                //将Button的颜色赋给Collection
                UIColor *color=self.colorArray[self.viewTag];
                self.collectionView.backgroundColor=color;
                
               // NSLog(@"%ld", self.dataArray.count);
                [self barImageViewClicked:[self.view viewWithTag:1000]];
                //更新UI
                [self.collectionView reloadData];
            });
            
        }else{
            NSLog(@"解析错误！！");
        }
    }];
    [task resume];
}

#pragma mark ---------CollectionView---------------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Model *model=self.dataArray[indexPath.row];
    cell.dateLabel.text=[NSString stringWithFormat:@"📅 %@",model.day];
    [cell.dayImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.day_weather_pic]]];
    [cell.nightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.night_weather_pic]]];
    cell.dayWeatherLabel.text=[NSString stringWithFormat:@"白天天气:%@",model.day_weather];
    cell.nightWeatherLabel.text=[NSString stringWithFormat:@"夜晚天气:%@",model.night_weather];
    cell.dayTemperatureLabel.text=[NSString stringWithFormat:@"%@℃",model.day_air_temperature];
    cell.nightTemperatureLabel.text=[NSString stringWithFormat:@"%@℃",model.night_air_temperature];
    cell.day_wind_direction.text=model.day_wind_direction;
    cell.night_wind_direction.text=model.night_wind_direction;
    cell.day_wind_power.text=model.day_wind_power;
    cell.night_wind_power.text=model.night_wind_power;
    cell.sun_begin_end.text=[NSString stringWithFormat:@"🌄日出%@日落🌅",model.sun_begin_end];
    //cell.addressLabel.text=self.city;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
    
}
#pragma mark ----------BarViews-----------
-(void)z_barViews
{
    NSInteger tt = 100;
    NSInteger bb=1000;
    //循环加入按钮
    for (int i = 0; i< 7; i++) {
        self.barView = [[UIView alloc]init];
        self.barView.frame=CGRectMake(i*(kBarWidth+2)+2,self.view.frame.size.height-self.buttonY, kBarWidth, kBarHeight + 10);
        self.barView.backgroundColor =[UIColor whiteColor];
        self.barView.tag = tt+ i;
        self.barView.layer.cornerRadius = 8;
        [self.view addSubview:self.barView];
        
        self.button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.button.frame=CGRectMake(4, 4, CGRectGetWidth(self.barView.frame) - 8, CGRectGetWidth(self.barView.frame) - 8);
        self.button.backgroundColor = [UIColor colorWithHue:arc4random()%255/256.0 saturation:0.5 brightness:0.9 alpha:1];
        //创建一个color来存储Button的color
        UIColor *color=[[UIColor alloc]init];
        color=self.button.backgroundColor;
        [self.colorArray addObject:color];
        
        self.button.layer.cornerRadius = 8;
        self.button.tag=bb+i;
        [self.button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.button addTarget:self action:@selector(barImageViewClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.barView addSubview:self.button];
    }
    //将第一个按钮推上
    UIView *temp = [self.view viewWithTag:100];
    temp.frame =CGRectMake(2, self.view.frame.size.height-self.buttonY-45, kBarWidth, kBarHeight + 10);
    
    
    
}
//点击下方按钮方法
- (void)barImageViewClicked:(UIButton *)sender
{
    //给点击的按钮赋值
    Model *model=self.dataArray[(sender.tag-1000)];
    NSString *str=[NSString stringWithFormat:@"%@",model.weekday];
    if ([str isEqual:@"1"]) {
        [sender setTitle:@"周一" forState:(UIControlStateNormal)];
    }else if([str isEqualToString:@"2"]){
        [sender setTitle:@"周二" forState:(UIControlStateNormal)];
    }else if([str isEqualToString:@"3"]){
        [sender setTitle:@"周三" forState:(UIControlStateNormal)];
    }else if([str isEqualToString:@"4"]){
        [sender setTitle:@"周四" forState:(UIControlStateNormal)];
    }else if([str isEqualToString:@"5"]){
        [sender setTitle:@"周五" forState:(UIControlStateNormal)];
    }else if([str isEqualToString:@"6"]){
        [sender setTitle:@"周六" forState:(UIControlStateNormal)];
    }else if([str isEqualToString:@"7"]){
        [sender setTitle:@"周日" forState:(UIControlStateNormal)];
    }
    
    //添加动画
    [UIView animateWithDuration:0.5 animations:^{
        //点击按钮后使CollectionView偏移
        self.collectionView.contentOffset= CGPointMake(kWidth * ((sender.tag) - 1000),0);
        //得到当前偏移了几个屏幕宽度
        self.viewTag =self.collectionView.contentOffset.x/kWidth ;
        //按钮下View的tag值
        UIView *temp = [self.view viewWithTag:(100 + self.viewTag)];
        ;
        temp.frame =CGRectMake(self.viewTag*(kBarWidth+2)+2, self.view.frame.size.height-self.buttonY-(CGRectGetWidth(self.view.frame)/8.3), kBarWidth, kBarHeight +10);
        //右边的Button和view回去
        for (int i = 1; i< 7; i++) {
            UIView *temp = [self.view viewWithTag:(100+i) + self.viewTag];
            temp.frame = CGRectMake((self.viewTag+i)*(kBarWidth+2)+2, self.view.frame.size.height - self.buttonY, kBarWidth, kBarHeight+10);
        }
        //左边的Button和view回去
        for (int i = 1; i <7; i++) {
            UIView *temp = [self.view viewWithTag:(100-i) + self.viewTag];
            temp.frame = CGRectMake((self.viewTag -i)*(kBarWidth+2)+2, self.view.frame.size.height - self.buttonY, kBarWidth, kBarHeight+10);
            
        }
        
        
    }];
    //将Button的颜色赋给Collection
    UIColor *color=self.colorArray[self.viewTag];
    self.collectionView.backgroundColor=color;
     [ self.navigationController.navigationBar setBarTintColor:color];
}

#pragma mrak ----scrollView------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //加动画
    [UIView animateWithDuration:0.5 animations:^{
        //获取滑动了几个屏幕宽度
        self.viewTag =self.collectionView.contentOffset.x/kWidth ;
        UIView *temp = [self.view viewWithTag:(100 + self.viewTag)];
        ;
        temp.frame =CGRectMake(self.viewTag*(kBarWidth+2)+2, self.view.frame.size.height-self.buttonY-45, kBarWidth, kBarHeight +10);
        [self barImageViewClicked:[self.view viewWithTag:(1000 +self.viewTag)]];
        //滑动后右边的Button回去
        for (int i = 1; i< 7; i++) {
            UIView *temp = [self.view viewWithTag:(100+i) + self.viewTag];
            temp.frame = CGRectMake((self.viewTag+i)*(kBarWidth+2)+2, self.view.frame.size.height - self.buttonY, kBarWidth, kBarHeight+10);
            
        }
        //滑动后左边的Button回去
        for (int i = 1; i <7; i++) {
            UIView *temp = [self.view viewWithTag:(100-i) + self.viewTag];
            temp.frame = CGRectMake((self.viewTag -i)*(kBarWidth+2)+2, self.view.frame.size.height - self.buttonY, kBarWidth, kBarHeight+10);
            
        }
        
    }];
    //将Button的颜色赋给Collection
    UIColor *color=self.colorArray[self.viewTag];
    self.collectionView.backgroundColor=color;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

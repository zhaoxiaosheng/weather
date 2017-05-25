//
//  WeatherCityViewController.m
//  GodBlanket
//
//  Created by Z_小圣 on 15/12/12.


#import "WeatherCityViewController.h"
#import "WeatherCityModel.h"
#import "Single.h"
#import "MBProgressHUD.h"
@interface WeatherCityViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@property(strong,nonatomic)UIButton *cityButton;
@end

@implementation WeatherCityViewController
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray=[NSMutableArray array];
    
    }
    return _dataArray;
}

- (NSMutableArray *)indexArray
{
    if (_indexArray == nil) {
        self.indexArray = [NSMutableArray array];
        self.indexArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"].mutableCopy;
    }
    return _indexArray;
}

- (NSMutableArray *)cityArray
{
    if (_cityArray == nil) {
        self.cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 63, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:(UITableViewStyleGrouped)];
        [self.view addSubview:self.tableView];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        //索引
        self.tableView.sectionIndexColor = [UIColor colorWithRed:0.867 green:0.231 blue:0.290 alpha:1];
        [self addHeaderView];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self markdata];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.2 alpha:0.6]];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title=@"城市列表";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(leftButton)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    UIColor *color=[UIColor whiteColor];
    [ self.navigationController.navigationBar setBarTintColor:color];
    
}
-(void)leftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
//添加headerView
- (void)addHeaderView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 90)];
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth(self.view.frame) - 20, 30)];
    lable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lable.text = @"根据当前定位，推荐以下城市";
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = [UIColor grayColor];
    [view addSubview:lable];
    UIView * citybgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lable.frame), CGRectGetWidth(self.view.frame), 45)];
    citybgView.backgroundColor = [UIColor whiteColor];
    [view addSubview:citybgView];
    self.cityButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.cityButton.frame=CGRectMake(15, CGRectGetMaxY(lable.frame), CGRectGetWidth(self.view.frame) - 30, 45);
    self.cityButton.backgroundColor = [UIColor whiteColor];
    [self.cityButton setTitle:[NSString stringWithFormat:@"%@",self.localCity] forState:(UIControlStateNormal)];
    [self.cityButton addTarget:self action:@selector(cityButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cityButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.cityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [view addSubview:self.cityButton];
    self.tableView.tableHeaderView = view;
}


-(void)cityButtonAction
{
    Single *s= [Single shareSingle];
    s.aString=self.localCity;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------markdata------
-(void)markdata
{
NSURLSessionDataTask *task=[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://nahaowan.com/api/v3/city/list"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (data != nil) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        for (NSDictionary *dict in dic[@"data"][@"list"]) {
            WeatherCityModel *model=[[WeatherCityModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
        for (int i = 0; i < self.indexArray.count; i++) {
            NSMutableDictionary *cityDic=[NSMutableDictionary dictionary];
            NSMutableArray *arr=[NSMutableArray array];
            for (WeatherCityModel *model in self.dataArray) {
                if ([model.alpha_index isEqualToString:self.indexArray[i]]) {
                    [arr addObject:model];
                }
            }
            [cityDic setValue:arr forKey:self.indexArray[i]];
            [self.cityArray addObject:cityDic];
        }
        //NSLog(@"%@", self.cityArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            

            [self.tableView reloadData];
        });
    }
}];
    [task resume];


}
#pragma mark ------uitableView--------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dic = self.cityArray[section];
    NSArray * array = dic[self.indexArray[section]];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary * dic = self.cityArray[indexPath.section];
    NSArray * array = dic[self.indexArray[indexPath.section]];
    WeatherCityModel *model = array[indexPath.row];
    cell.textLabel.text=model.name;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.cityArray[indexPath.section];
    NSArray * array = dic[self.indexArray[indexPath.section]];
    WeatherCityModel *model = array[indexPath.row];
    Single *s= [Single shareSingle];
    s.aString=model.name;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return self.indexArray[section];
}

//索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //弹出首字母提示
    
    [self showLetter:title ];
    
    return index;
}

//展示标题
- (void)showLetter:(NSString *)title
{
    //获取window
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    self.hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.delegate = self;
    self.hud.labelText = title;
    self.hud.dimBackground = NO;
    [self.hud hide:YES afterDelay:0.5];
}

#pragma mark ---hud代理方法
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.hud removeFromSuperview];
    self.hud = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  DevicesViewController.m
//  Grunwl
//
//  Created by mojingyu on 16/5/23.
//  Copyright © 2016年 Mojy. All rights reserved.
//

#import "DevicesViewController.h"
#import "VerifyViewController.h"

@interface DevicesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSArray *deviceArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DevicesViewController

- (id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.deviceArray = devices;
    }
    
    return self;    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBAlphaColor(0, 112, 192, 1);
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
#ifdef FLOTEQ
    UIImage *logoImage = [UIImage imageNamed:@"logo_floteq"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    logoImageView.backgroundColor = [UIColor whiteColor];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SYRealValue(30));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SYRealValue(60));
    }];
    
#else
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 50)];
    titleLabel.backgroundColor = WhiteColor;
    titleLabel.textColor = BlackColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Font(30);
    titleLabel.text = GRUNWL;
    [self.view addSubview:titleLabel];
#endif
    
    [self initCollectionView:CGRectMake(0, 150, ScreenWidth, ScreenHeight-150)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceInfo) name:Notify_DiscoverDevice object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIcollectionView
- (void)initCollectionView:(CGRect)frame
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
//        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self.view addSubview:_collectionView];
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.deviceArray.count;   //
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"Cell";
    UICollectionViewCell *cell = (UICollectionViewCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    
    cell.backgroundColor = WhiteColor;
    
    NSString *name;
    
    if (indexPath.row < self.deviceArray.count) {
        CBPeripheral *peripheral = [self.deviceArray objectAtIndex:indexPath.row];
        //    NSString *name = [NSString stringWithFormat:@"GRUNWL-%ld", indexPath.row+1];
        
        if ([[peripheral.name uppercaseString] containsString:@"GRUNWL-"])
            name = [peripheral.name substringFromIndex:7];
        else
            name = peripheral.name;
    }
    
    CGFloat cellWidth = (ScreenWidth - 60) *0.5;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 50)];
    textLabel.text = name;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = BlackColor;
    textLabel.font = Font(20);
    [cell addSubview:textLabel];
    
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = (ScreenWidth - 60) *0.5;
    return CGSizeMake(cellWidth, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}


#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    static BOOL isConnect = NO;
    
    isConnect = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Operation object:nil];
    [MBProgressHUD showMessage:nil];
    CBPeripheral *peripheral = [self.deviceArray objectAtIndex:indexPath.row];
    [[BluetoothManager sharedInstance] connectPeripheral:peripheral onConnectedBlock:^{
        //
        if (!isConnect) {
            isConnect = YES;
            [MBProgressHUD hideHUD];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Connected object:nil];
            
            NSString *name;
            if ([[peripheral.name uppercaseString] containsString:@"GRUNWL-"])
                name = [peripheral.name substringFromIndex:7];
            else
                name = peripheral.name;
            
            //连接上后跳转到验证页面
            VerifyViewController *viewController = [[VerifyViewController alloc] init];
            viewController.deviceID = name;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 更新界面
- (void)updateDeviceInfo
{
    self.deviceArray = [BluetoothManager sharedInstance].deviceArray;
    [self.collectionView reloadData];
}


@end

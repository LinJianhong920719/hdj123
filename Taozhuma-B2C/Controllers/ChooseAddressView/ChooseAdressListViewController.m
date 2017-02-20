//
//  ChooseAdressListViewController.m
//
//  Created by yusaiyan on 15/8/11.
//  Copyright (c) 2015年 lixinfan. All rights reserved.
//

#import "ChooseAdressListViewController.h"
#import "ChooseAddressCell.h"
#import "ProductDetailViewController.h"
#import "ChooseAddressEntity.h"

#define Reality_viewHeight ScreenHeight-ViewOrignY-40-50
#define Reality_viewWidth ScreenWidth

@interface ChooseAdressListViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>{

    NSString *tagOrder;
    UIView *topView;
    UITextField *searchField;

}


@property (nonatomic, strong) NSMutableArray* data;

@end

@implementation ChooseAdressListViewController
@synthesize mTableView = _mTableView;
@synthesize data = _data;
@synthesize content;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideNaviBar:YES];
    [self initTopNav];
    [self initUI];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化UI

-(void)initTopNav{
    //自定义导航栏
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    //返回
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 23, 28, 33)];
    [backButton setImage:[UIImage imageNamed:@"header_back"] forState:UIControlStateNormal];//设置按钮的图片
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10) ];//将按钮的上下左右都缩进8个单位
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];//为按钮增加时间侦听
    [topView addSubview:backButton];

    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(viewRight(backButton)+10, 24, DEVICE_SCREEN_SIZE_WIDTH-65, 30)];
    searchView.backgroundColor = RGB(239, 239, 239);
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
    [searchImageView setImage:[UIImage imageNamed:@"icon_search"]];
    [searchView addSubview:searchImageView];
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(searchImageView)+5, 0, DEVICE_SCREEN_SIZE_WIDTH-backButton.frame.size.width-20, 30)];

    searchField.font = [UIFont systemFontOfSize:13];
    searchField.textColor = FONTS_COLOR102;
    searchField.placeholder = @"请输入小区名";
    //设置圆角
    searchField.delegate = self;
    searchField.keyboardType = UIKeyboardTypeDefault;
    searchField.returnKeyType = UIReturnKeyDone;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchField addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventEditingDidEndOnExit];

    [searchView addSubview:searchField];
    
    [topView addSubview:searchView];
    
    [self.view addSubview:topView];
    [self.view bringSubviewToFront:topView];
}

- (void)initUI {
    
    _data = [[NSMutableArray alloc]init];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewOrignY+5, Reality_viewWidth, ScreenHeight-ViewOrignY-5) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.scrollsToTop = YES;
    _mTableView.backgroundColor = self.view.backgroundColor;
    _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_mTableView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Reality_viewWidth, 1)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    _mTableView.tableFooterView = tableFooterView;
  
}


#pragma mark - 加载数据

- (void)loadData {


    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         searchField.text,     @"content",
//                         @"汇",     @"content",
                         nil];
    
    NSString *path = [NSString stringWithFormat:@"/Api/Community/Search?"];
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:path refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSLog(@"response:%@",response);
        NSString *statusMsg = [dic valueForKey:@"status"];
        if([statusMsg intValue] == 4001 || [statusMsg intValue] == 4002){
            //弹框提示获取失败
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"获取失败!";
            hud.yOffset = -50.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            return;
        }if([statusMsg intValue] == 201){
            [self showHUDText:@"无数据!"];
        }else{
            [_data removeAllObjects];
            if([[dic valueForKey:@"data"] count] > 0 && [dic valueForKey:@"data"] != nil){
                for(NSDictionary *adrDiction in [dic valueForKey:@"data"]){
                    
                    ChooseAddressEntity *entity = [[ChooseAddressEntity alloc]initWithAttributes:adrDiction];
                    [_data addObject:entity];
                    
                }
                [_mTableView reloadData];
            }
            
        }

    } fail:^(NSError *error) {
        
    }];
}



#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseAddressCell *cell = (ChooseAddressCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChooseAddressCell";
    ChooseAddressCell *cell = (ChooseAddressCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChooseAddressCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([_data count] > 0) {
        ChooseAddressEntity *entity = [_data objectAtIndex:[indexPath row]];
        
        cell.communityName.text = entity.communityName;
        cell.addressDetail.text = entity.addressDetail;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseAddressEntity *entity = [_data objectAtIndex:[indexPath row]];
    
    [Tools saveObject:entity.communityName forKey:COMMUNITYNAME];
    [Tools saveObject:entity.communityId forKey:COMMUNITYID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refCommunity" object:entity.communityId];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [_mTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)backClick:(id)sender {
    // 返回上页
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)searchBtnClicked:(id)sender {
    [self loadData];
    
}


@end

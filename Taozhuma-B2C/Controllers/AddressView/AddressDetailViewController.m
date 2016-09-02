//
//  AddressDetailViewController.m
//  Taozhuma-B2C
//
//  Created by Average on 16/8/26.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "AddressPickView.h"
#import "IQKeyBoardManager.h"
#import "LTPickerView.h"
@interface AddressDetailViewController ()<UIActionSheetDelegate,UITextFieldDelegate>{
    UILabel *userName;
    UITextField *userNameField;
    UILabel *userSex;
    UITextField *userSexField;
    UILabel *userPhone;
    UITextField *userPhoneField;
    UILabel *userArea;
    UITextField *userAreaField;
    UILabel *userCom;
    UITextField *userComField;
    UILabel *userAddress;
    UITextField *userAddressField;
    NSString *sexNum;
    NSMutableArray *comNameArray;
    NSMutableArray *comIdArray;
    NSString *communityId;//小区id
    NSString *communityName;//小区名称
    UIAlertView *alert;
    UITextView *myUITextView;
}

@end

@implementation AddressDetailViewController
@synthesize addressId;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [IQKeyBoardManager installKeyboardManager];
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;//手势敲击的次数
    [self.view addGestureRecognizer:gesture];
    comNameArray = [[NSMutableArray alloc]init];
    comIdArray = [[NSMutableArray alloc]init];
    [self loadAddressMsg];
}
-(void)initUI{

    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewOrignY+20, DEVICE_SCREEN_SIZE_WIDTH, 163)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    //联系人
    userName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    userName.text = @"联系人";
    userName.textAlignment = NSTextAlignmentCenter;
    userName.font = [UIFont systemFontOfSize:14];
    userName.textColor = FONTS_COLOR102;
    [baseView addSubview:userName];
    
    userNameField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(userName)+10, 0, DEVICE_SCREEN_SIZE_WIDTH-userName.frame.size.width-20, 40)];
    userNameField.placeholder = @"收货人姓名";
    userNameField.font = [UIFont systemFontOfSize:14];
    userNameField.textColor = FONTS_COLOR153;
    userNameField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    //设置圆角
    userNameField.delegate = self;
    userNameField.keyboardType = UIKeyboardTypeDefault;
    userNameField.returnKeyType = UIReturnKeyNext;
    userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userNameField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:userNameField];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(userNameField), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    line1.backgroundColor = LINECOLOR_DEFAULT;
    [baseView addSubview:line1];
    
    //性别
    userSex = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line1), 80, 40)];
    userSex.text = @"性别";
    userSex.textAlignment = NSTextAlignmentCenter;
    userSex.font = [UIFont systemFontOfSize:14];
    userSex.textColor = FONTS_COLOR102;
    [baseView addSubview:userSex];
    
    
    userSexField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(userSex)+10, viewBottom(line1), DEVICE_SCREEN_SIZE_WIDTH-userSex.frame.size.width-20, 40)];
    userSexField.placeholder = @"请选择您的性别";
    userSexField.font = [UIFont systemFontOfSize:14];
    userSexField.textColor = FONTS_COLOR153;
    userSexField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);

    [userSexField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:userSexField];
    
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(userSexField), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    line2.backgroundColor = LINECOLOR_DEFAULT;
    [baseView addSubview:line2];
    
    //手机号码
    userPhone = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line2), 80, 40)];
    userPhone.text = @"手机号码";
    userPhone.textAlignment = NSTextAlignmentCenter;
    userPhone.font = [UIFont systemFontOfSize:14];
    userPhone.textColor = FONTS_COLOR102;
    [baseView addSubview:userPhone];
    
    userPhoneField = [[UITextField alloc]initWithFrame:CGRectMake(viewRight(userPhone)+10, viewBottom(line2), DEVICE_SCREEN_SIZE_WIDTH-userPhone.frame.size.width-20, 40)];
    userPhoneField.placeholder = @"请输入您的手机号码";
    userPhoneField.font = [UIFont systemFontOfSize:14];
    userPhoneField.textColor = FONTS_COLOR153;
    userPhoneField.backgroundColor = UIColorWithRGBA(255, 255, 255, 0.5);
    //设置圆角
    userPhoneField.delegate = self;
    userPhoneField.keyboardType = UIKeyboardTypeDefault;
    userPhoneField.returnKeyType = UIReturnKeyNext;
    userPhoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [userPhoneField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [baseView addSubview:userPhoneField];
    
    UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, viewBottom(userPhoneField), DEVICE_SCREEN_SIZE_WIDTH-20, 1)];
    
    line3.backgroundColor = LINECOLOR_DEFAULT;
    [baseView addSubview:line3];
    
 
    //详细地址
    userAddress = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(line3), 80, 40)];
    userAddress.text = @"详细地址";
    userAddress.textAlignment = NSTextAlignmentCenter;
    userAddress.font = [UIFont systemFontOfSize:14];
    userAddress.textColor = FONTS_COLOR102;
    [baseView addSubview:userAddress];
    
    myUITextView = [[UITextView alloc]initWithFrame:CGRectMake(viewRight(userAddress)+10, viewBottom(line3), DEVICE_SCREEN_SIZE_WIDTH-userAddress.frame.size.width-20,40)];
//    myUITextView.text=@"强势求粉，有楼行遍天下，无粉寸步难行，人人粉我，我粉人人，抗议不回复";
    [baseView addSubview: myUITextView ];

    
    UIView *delAddress = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(baseView)+20, DEVICE_SCREEN_SIZE_WIDTH, 40)];
    delAddress.backgroundColor = [UIColor whiteColor];
    UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 40)];
    [delBtn setTitle:@"删除地址" forState:UIControlStateNormal];
    [delBtn setTitleColor:FONTS_COLOR102 forState:UIControlStateNormal];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [delBtn addTarget:self action:@selector(delAddressMsg:) forControlEvents:UIControlEventTouchUpInside];
    [delAddress addSubview:delBtn];
    
    [self.view addSubview:delAddress];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    if (sender == userNameField) {
        [userSexField becomeFirstResponder];
    }else if (sender == userSexField) {
        [userPhoneField becomeFirstResponder];
    }else if (sender == userPhoneField) {
        [userAreaField becomeFirstResponder];
    }else if (sender == userAreaField) {
        [userComField becomeFirstResponder];
    }else if (sender == userComField) {
        [userAddressField becomeFirstResponder];
    }else if (sender == userAddressField) {
        [self hideKeyboard];
    }
}


//隐藏键盘方法
-(void)hideKeyboard{
    [userNameField resignFirstResponder];
    [userSexField resignFirstResponder];
    [userPhoneField resignFirstResponder];
    [userAreaField resignFirstResponder];
    [userComField resignFirstResponder];
    [userAddressField resignFirstResponder];
}



//小区
- (IBAction)comPickerView:(id)sender {
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = comNameArray;//设置要显示的数据
    //    pickerView.defaultStr = @"男";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        NSLog(@"选择了第%d行的%@",num,str);
        userComField.text = str;
        communityId = comIdArray[num];
        NSLog(@"小区ID:%@;小区名称为:%@",communityId,str);
        
    };
}

//获取地址详情信息
- (void)loadAddressMsg {
    
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          addressId,  @"id",
                          nil];
    
    NSString *xpoint = @"/Api/User/AddressDetail?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        }else if([statusMsg intValue] == 201){
            //弹框提示获取失败
            [self showHUDText:@"暂无内容!"];
        }else {
            
            NSArray *data = [dic valueForKey:@"data"];
            userNameField.text = [data valueForKey:@"guest_name"];
            if ([[data valueForKey:@"guest"] isEqualToString:@"0"]) {
                userSexField.text = @"男";
            }else{
                userSexField.text = @"女";
            }
            userPhoneField.text = [data valueForKey:@"mobile"];
            myUITextView.text = [data valueForKey:@"address"];
            

        }
        
    } fail:^(NSError *error) {
        
    }];
    
}
//删除地址信息
- (IBAction)delAddressMsg:(id)sender{

    
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                          addressId,  @"id",
                          nil];
    
    NSString *xpoint = @"/Api/User/delAddress?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dics success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        
        if([statusMsg intValue] == 4001){
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        }else if([statusMsg intValue] == 201){
            //弹框提示获取失败
            [self showHUDText:@"附近暂无合作小区!"];
        }else {
            [self showHUDText:@"删除成功!"];
            //通知 发出
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refAddressList" object:nil];
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}


@end

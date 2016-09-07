//
//  EditUserInfoViewController.m
//  修改个人信息
//
//  Created by yusaiyan on 15/6/1.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "IQKeyBoardManager.h"
#import "CustomViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MineViewControllers.h"
#import "ELCAssetTablePicker.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@interface EditUserInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate> {
    UIDatePicker *datePicker;
    UIButton *userInfo;
    UIButton *rightBtn;
    UIAlertView *alert;
    UITextField * name;
    UIImageView *headImage; //头部头像背景图
    UIImagePickerController *imagePicker;
    UIImage *m_selectImage;
    NSData *imageData;
}
@end

@implementation EditUserInfoViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initView];
    [self loadData];
    [IQKeyBoardManager installKeyboardManager];
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;//手势敲击的次数
    [self.view addGestureRecognizer:gesture];
    
    
    
    //导航栏右侧按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:PRODUCT_COLOR forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize: 15];
    [rightBtn addTarget:self action:@selector(butSubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNaviBarRightBtn:rightBtn];
}
- (void)initView {
    
    UIView *fieldImageView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewOrignY+13, DEVICE_SCREEN_SIZE_WIDTH, 120)];
    [fieldImageView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:fieldImageView];
    
    UILabel *logoLabel = [[UILabel alloc]initWithFrame:CGRectMake(PROPORTION414*20, 1, 60, 75)];
    logoLabel.text = @"头像";
    [logoLabel setTextColor:UIColorWithRGBA(62, 58, 57, 1)];
    logoLabel.font = [UIFont systemFontOfSize:14];
    [fieldImageView addSubview:logoLabel];
    
    UILabel *nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(PROPORTION414*20, 76, 60, 43)];
    nickLabel.text = @"昵称";
    [nickLabel setTextColor:UIColorWithRGBA(62, 58, 57, 1)];
    nickLabel.font = [UIFont systemFontOfSize:14];
    [fieldImageView addSubview:nickLabel];
    
    
    
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 1)];
    line.backgroundColor = LINECOLOR_DEFAULT;
    [fieldImageView addSubview:line];
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 76, DEVICE_SCREEN_SIZE_WIDTH-30, 1)];
    line2.backgroundColor = LINECOLOR_DEFAULT;
    [fieldImageView addSubview:line2];
    UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 120, DEVICE_SCREEN_SIZE_WIDTH-30, 1)];
    line3.backgroundColor = LINECOLOR_DEFAULT;
    [fieldImageView addSubview:line3];
    
    UIImageView *arrow1 = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-30, 32, 6, 11)];
    [arrow1 setImage:[UIImage imageNamed:@"wm-097.png"]];
    [fieldImageView addSubview:arrow1];
    
    UIImageView *arrow2 = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-30, 92, 6, 11)];
    [arrow2 setImage:[UIImage imageNamed:@"wm-097.png"]];
    [fieldImageView addSubview:arrow2];
    
    
    
    
    headImage = [[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*42-51, 10, 51, 51)];
    [headImage.layer setCornerRadius:51/2];
    [headImage.layer setMasksToBounds:YES];
    [fieldImageView addSubview:headImage];
    
    userInfo = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 51)];
    [userInfo addTarget:self action:@selector(showSheet:) forControlEvents:UIControlEventTouchUpInside];
    [fieldImageView addSubview:userInfo];
    
    
    //       昵称输入框
    name = [[UITextField alloc]initWithFrame:CGRectMake(DEVICE_SCREEN_SIZE_WIDTH-PROPORTION414*42-200, 76, 200, 43)];
    [name setFont:[UIFont systemFontOfSize:14]];
    name.textColor = UIColorWithRGBA(89, 87, 87, 1);
    name.delegate = self;
    name.textAlignment = NSTextAlignmentRight;
    name.keyboardType = UIKeyboardTypeDefault;
    name.returnKeyType = UIReturnKeyDone;
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    name.placeholder = @"请输入昵称";
    [fieldImageView addSubview:name];
    [name addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
}

- (IBAction)showSheet:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 255;
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 255) {
        
        if (buttonIndex == 0) {
            [self touch_photo];
        } else if(buttonIndex == 1) {
            [self pickImageFromCamera];
        }
        
    }
    
}

#pragma mark - UIImagePickerController

- (void)pickImageFromCamera {
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//打开相机
- (void)touch_photo {
    // for iphone
    imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    }
    imagePicker.delegate = self;
    //自定义照片样式
    imagePicker.allowsEditing = NO;
    //设置相机支持的类型 拍照kUTTypeImage,录像kUTTypeMovie
    //    imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    NSLog(@"info:%@",[info objectForKey:@"UIImagePickerControllerOriginalImage"]);
    //初始化imageNew为从相机中获得的--
    UIImage *imageNew = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //设置image的尺寸
    CGSize imagesize = imageNew.size;
    
    imagesize.width = 300;
    imagesize.height = 300 / imageNew.size.width * imageNew.size.height;
    //对图片大小进行压缩--
    imageNew = [self imageWithImage:imageNew scaledToSize:imagesize];
    imageData = UIImageJPEGRepresentation(imageNew,0.2);
    headImage.image = [UIImage imageWithData:imageData];
    NSLog(@"[UIImage imageWithData:imageData]:%@",[UIImage imageWithData:imageData]);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    return ;
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)loadData {
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],     @"uid",
                         nil];
    NSLog(@"%@", dic);
    NSString *xpoint = @"/Api/User/getInfo";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    [HYBNetworking getWithUrl:xpoint refreshCache:YES emphasis:NO params:dic success:^(id response) {
        
        NSDictionary *dic = response;
        NSString *statusMsg = [dic valueForKey:@"status"];
        NSLog(@"statusMsg:%@",statusMsg);
        
        
        
        if ([statusMsg intValue] == 201) {
            //弹框提示获取失败
            [self showHUDText:@"暂无数据"];
            
        }else if ([statusMsg intValue] == 4001) {
            //弹框提示获取失败
            [self showHUDText:@"获取失败!"];
            
        } else {
            
            NSArray *data = [dic valueForKey:@"data"];
            
            if ([data count] > 0) {
                name.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"u_nickname"]];
                if ([data valueForKey:@"u_image"]==nil) {
                    headImage.image = [UIImage imageNamed:@"user_default"];
                } else {
                 
                    [headImage sd_setImageWithURL:[NSURL URLWithString:[data valueForKey:@"u_image"]] placeholderImage:[UIImage imageNamed:@"user_default"]];
                }
            }
            
        
        
    }
     
     } fail:^(NSError *error) {
         
     }];
    //        [MailWorldRequest requestWithParams:dic xpoint:xpoint andBlock:^(MailWorldRequest *respond, NSError *error) {
    //            if (error) {
    //                [HUD removeFromSuperview];
    //            } else {
    //                if (respond.result == 1) {
    //                    if(respond.respondData > 0){
    //                        name.text = [NSString stringWithFormat:@"%@",[respond.respondData valueForKey:@"nikename"]];
    //                        [Tools saveObject:[respond.respondData valueForKey:@"nikename"] forKey:KEY_NIKE_NAME];
    //                        if ([respond.respondData valueForKey:@"head_icon"]==nil) {
    //
    //                            headImage.image = [UIImage imageNamed:@"wm-088"];
    //                        } else {
    //
    //                            [Tools saveObject:[respond.respondData valueForKey:@"head_icon"] forKey:KEY_HEAD_ICON];
    //                            [headImage sd_setImageWithURL:[NSURL URLWithString:[respond.respondData valueForKey:@"head_icon"]] placeholderImage:[UIImage imageNamed:@"wm-088"]];
    //                        }
    //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInfos" object:nil];
    //                    }
    //
    //                    [HUD removeFromSuperview];
    //
    //                }
    //            }
    //        }];
    
}

//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    if (sender == name) {
        [self hideKeyboard];
    }
}
//隐藏键盘方法
-(void)hideKeyboard{
    [name resignFirstResponder];
    
}
//提交申请
- (IBAction)butSubmitClick:(id)sender {
    
    if (name.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请填写您的昵称";
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
        hud.yOffset = -50.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return;
    }
    else if(name.text.length > 10){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"昵称过长";
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
        hud.yOffset = -50.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [Tools stringForKey:KEY_USER_ID],      @"userId",
                         name.text,                        @"nickname",
                         nil];
    NSLog(@"dic:%@",dic);
    NSData *imageToUpload = imageData;
    
    //    NSString *url = [SERVICE_URL stringByAppendingString:@"/Api/User/edit?"];
    NSString *xpoint = @"/Api/User/edit?";
    
    [HYBNetworking updateBaseUrl:SERVICE_URL];
    //    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:url]];
    //    [client setParameterEncoding:AFJSONParameterEncoding];
    //
    //    NSMutableURLRequest *requestURL = [client multipartFormRequestWithMethod:@"POST" path:url parameters:dic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    //        if (imageToUpload != nil) {
    //            [formData appendPartWithFileData:imageToUpload name:@"head_icon" fileName:@"credentials_img.jpg"  mimeType:@"image/jpg"];
    //        }
    //
    //    }];
    //    [requestURL setTimeoutInterval:10];
    /**
     *
     *
     *	图片上传接口，若不指定baseurl，可传完整的url
     *
     *	@param image			图片对象
     *	@param url				上传图片的接口路径，如/path/images/
     *	@param filename		给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
     *	@param name				与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
     *	@param mimeType		默认为image/jpeg
     *	@param parameters	参数
     *	@param progress		上传进度
     *	@param success		上传成功回调
     *	@param fail				上传失败回调
     *
     *	@return
     */
    [HYBNetworking uploadWithImage:[UIImage imageWithData:imageToUpload] url:xpoint filename:nil name:@"u_image"
                          mimeType:@"image/jpg"
                        parameters:dic
                          progress:nil
                           success:^(id response) {
                               
                               NSDictionary *dic = response;
                               NSString *statusMsg = [dic valueForKey:@"status"];
                               NSLog(@"statusMsg:%@",statusMsg);
                               NSLog(@"错误信息:%@",dic);
                               
                               if ([statusMsg intValue] == 201) {
                                   //弹框提示获取失败
                                   [self showHUDText:@"暂无数据"];
                                   
                               }else if ([statusMsg intValue] == 4001) {
                                   //弹框提示获取失败
                                   [self showHUDText:@"获取失败!"];
                                   
                               } else {
                                   
                                   [self showHUDText:@"成功!"];
                                   
                               }
                           }
                              fail:^(NSError *error) {
                                  NSLog(@"error:%@",error);
                                  
                              }];
    
    
    //    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestURL];
    //    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSError* error;
    //        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:kNilOptions error:&error];
    //
    //        DLog(@"responseObject:%@", json);
    //        int result = [[json valueForKey:@"success"]integerValue];
    //
    //        if (result == NO) {
    //            [HUD removeFromSuperview];
    //
    //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //            hud.mode = MBProgressHUDModeText;
    //            hud.labelText = @"修改失败";
    //            hud.yOffset = -50.f;
    //            hud.removeFromSuperViewOnHide = YES;
    //            [hud hide:YES afterDelay:2];
    //        } else {
    //            [HUD removeFromSuperview];
    //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //            hud.mode = MBProgressHUDModeText;
    //            hud.labelText = @"修改成功";
    //            hud.yOffset = -50.f;
    //            hud.removeFromSuperViewOnHide = YES;
    //            [hud hide:YES afterDelay:2];
    //            [self performSelector:@selector(refresh:) withObject:nil afterDelay:0.1];
    //
    //            UIViewController *target = nil;
    //            //遍历
    //            for (UIViewController * controller in self.navigationController.viewControllers) {
    //                //这里判断是否为你想要跳转的页面
    //                if ([controller isKindOfClass:[MineViewController class]]) {
    //                    target = controller;
    //                }
    //            }
    //            if (target) {
    //
    //                //跳转
    //                [self.navigationController popToViewController:target animated:YES];
    //
    //
    //            }
    //
    //
    //
    //        }
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        if (error) {
    //            [HUD removeFromSuperview];
    //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //            hud.mode = MBProgressHUDModeText;
    //            hud.labelText = @"资料提交失败，请重试";
    //            hud.yOffset = -50.f;
    //            hud.removeFromSuperViewOnHide = YES;
    //            [hud hide:YES afterDelay:2];
    //        }
    //    }];
    //    [client enqueueHTTPRequestOperation:operation];
    
}

- (IBAction)refresh:(id)sender {
    
    [self loadData];
}


@end

//
//  CommentOrderViewController.m
//  Taozhuma-B2C
//
//  Created by edz on 17/2/9.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "CommentOrderViewController.h"
#import "CommentOrderCell.h"
#import "AllOrderEntity.h"

@interface CommentOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
}

@end

@implementation CommentOrderViewController

@synthesize tableView;
@synthesize commentArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    commentArray = [[NSMutableArray alloc]init];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44,DEVICE_SCREEN_SIZE_WIDTH, DEVICE_SCREEN_SIZE_HEIGHT-ViewOrignY) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorWithRGBA(238, 239, 239, 1);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_SIZE_WIDTH, 40)];
    [tableFooterView setBackgroundColor:UIColorWithRGBA(238, 239, 239, 1)];
    tableView.tableFooterView = tableFooterView;
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setFrame:CGRectMake(20, 0, DEVICE_SCREEN_SIZE_WIDTH-40, 30)];
    submitBtn.backgroundColor = UIColorWithRGBA(255, 80, 0, 1);
    [submitBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(sumbit) forControlEvents:UIControlEventTouchUpInside];
    
    [tableFooterView addSubview:submitBtn];
    
    
    
}


#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentOrderCell *cell = (CommentOrderCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data._carts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CommentOrderCell";
    CommentOrderCell *cell = (CommentOrderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentOrderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if ([_data._carts count] > 0) {
        
        if ([self isBlankString:[[_data._carts objectAtIndex:[indexPath row]] valueForKey:@"good_image"]]) {
            cell.productImage.image = [UIImage imageNamed:@"暂无图片"];
        } else {
            [cell.productImage sd_setImageWithURL:[NSURL URLWithString:[[_data._carts objectAtIndex:[indexPath row]] valueForKey:@"good_image"]] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        }
        cell.productName.text = [[_data._carts objectAtIndex:[indexPath row]] valueForKey:@"good_name"];
        cell.productComment.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.productComment.returnKeyType = UIReturnKeyDone;
        cell.productComment.delegate = self;
    }
    return cell;
}

#pragma mark - UITextField 相关操作

// ----------------------------------------------------------------------------------------
// 文本框失去first responder 时，执行
// ----------------------------------------------------------------------------------------
- (void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *cell  = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    NSString *note = [NSString stringWithFormat:@"%@:%@",[[_data._carts objectAtIndex:[indexPath row]] valueForKey:@"id"],textField.text];
    NSLog(@"array1:%@",commentArray);
    if(![commentArray containsObject:note]){
        [commentArray addObject:note];
    }

}

// ----------------------------------------------------------------------------------------
// 键盘上的 return
// ----------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    UITableViewCell *cell  = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    NSString *note = [NSString stringWithFormat:@"%@:%@",[[_data._carts objectAtIndex:[indexPath row]] valueForKey:@"id"],textField.text];
    NSLog(@"array2:%@",commentArray);
    if(![commentArray containsObject:note]){
        [commentArray addObject:note];
    }
    
    return YES;
}
-(void)sumbit{
    NSLog(@"array:%@",[commentArray objectAtIndex:1]);
    
    
    for (int i = 0; i < [commentArray count]; i++) {
        
        NSArray *array = [[commentArray objectAtIndex:i] componentsSeparatedByString:@":"];

        
        // 1. URL
        NSString *path = [NSString stringWithFormat:@"/Api/FeedBack/add?"];
        NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVICE_URL,path]];
        
        // 2. 请求(可以改的请求)
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        // ? POST
        // 默认就是GET请求
        request.HTTPMethod = @"POST";
        // ? 数据体
        NSString *str = [NSString stringWithFormat:@"goodId=%@&content=%@&userId=%@", [array objectAtIndex:0],[array objectAtIndex:1], [Tools stringForKey:KEY_USER_ID]];
        // 将字符串转换成数据
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        // 3. 连接,异步
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (connectionError == nil) {
                // 网络请求结束之后执行!
                // 将Data转换成字符串
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                // num = 2
                NSLog(@"%@ %@", str, [NSThread currentThread]);
                
                // 更新界面
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSLog(@"str:%@",str);
                    //弹框提示获取失败
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"评论成功";
                    hud.yOffset = -50.f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:2];
                    return;
                }];
            }
        }];
        }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

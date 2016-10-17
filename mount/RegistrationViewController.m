//
//  RegistrationViewController.m
//  mount
//
//  Created by mac on 15/4/7.
//
//

#import "RegistrationViewController.h"

@interface RegistrationViewController (){
    
    __weak IBOutlet UITextField *user;
    __weak IBOutlet UITextField *pass;
    
    __weak IBOutlet UITextField *passTo;
    NSMutableDictionary*dic;
    __weak IBOutlet UIButton *regButton;
}

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dic=[[UserDefaults objectForKey:@"userInfo"] mutableCopy];
    if (dic==nil) {
        dic=[[NSMutableDictionary alloc]init];
        [UserDefaults setValue:dic forKey:@"userInfo"];
    }
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"view.png"]];
    [regButton.layer setMasksToBounds:YES];
    [regButton.layer setCornerRadius:10.0];//设置矩形四个圆角半径
    [regButton.layer setBorderWidth:1.0];//边框宽度
    [regButton.layer setBorderColor:[UIColor blackColor].CGColor];
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)RegistrationAction{
    if (pass.text.length<3||passTo.text.length<3||user.text.length<3) {
        SHOW_ALERT(@"账号或密码太短", @"");
        return;
    }
    if (![passTo.text isEqualToString:pass.text]) {
        SHOW_ALERT(@"重复密码错误", @"");
        return;
    }
    [dic setValue:pass.text forKey:user.text];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)regAction:(id)sender {
    [self RegistrationAction];
}
-(void)viewDidDisappear:(BOOL)animated{
     [UserDefaults setValue:dic forKey:@"userInfo"];
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

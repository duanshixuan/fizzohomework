//
//  FYBaseViewController.m
//  ForYou
//
//  Created by marcus on 2017/7/28.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYBaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "FYRouter.h"
#import <FrameAccessor/FrameAccessor.h>
#import <ChameleonFramework/Chameleon.h>


typedef void(^ReloadBlock)();

@interface FYBaseViewController ()<FYNavigationBarDelegate>

@property (nonatomic, assign) Boolean bFirstAppear;




@property (nonatomic , copy)ReloadBlock reloadTouchBtn;

@property (nonatomic ,strong) MBProgressHUD *loadingHud;
    
@end

@implementation FYBaseViewController
@synthesize noDataPlaceholder = _noDataPlaceholder;
@synthesize noDataImageView = _noDataImageView;
@synthesize noDatalabel = _noDatalabel;

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDefaultStyle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.bFirstAppear) {
        [self viewWillFirstAppear];
        [self updateCustomInfo];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.bFirstAppear) {
        self.bFirstAppear = NO;
        [self viewDidFirstAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self fy_hideLoading];
}

#pragma mark - public methods
- (void)viewWillFirstAppear {
    
}

- (void)viewDidFirstAppear {
}

- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showRightButtonWithImage:(UIImage *)image title:(NSString *)title addTarget:(id)target action:(SEL)action {
    if (image) {
        self.navigationBar.rightButton.hidden = NO;
        [self.navigationBar.rightButton setImage:image forState:UIControlStateNormal];
    }
    if (![NSString isEmpty:title]) {
        self.navigationBar.rightButton.hidden = NO;
        [self.navigationBar.rightButton setTitle:title forState:UIControlStateNormal];
    }
    [self.navigationBar.rightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)fy_showLoading{
    [self fy_showLoadingIn:nil];
}

- (void)fy_showLoadingIn:(UIView *)view{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self.loadingHud hide:YES];
            self.loadingHud = [FYProgressHUD fy_loadingHudForView:view];
            [view bringSubviewToFront:self.loadingHud];
        });
    });

}

- (void)fy_hideLoading{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingHud hide:YES];
    });
}

- (void)fy_toastMessge:(NSString *)msg inView:(UIView *) view{
    [FYProgressHUD hideLoading];
    CGFloat offset = view.frame.size.height * .5 * .5;
    [FYProgressHUD toastMessgeLightly:msg
                               inView:view
                              Yoffset:offset];
}

- (void)fy_tipMesage:(NSString *)msg{
    [self.loadingHud hide:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (msg.length) {
            UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
            [FYProgressHUD show:msg image:nil view:keywindow];
        }
    });
}


-(void)showNoneInternetWithFrame:(CGRect)frame reload:(void (^)(void))reload{
    if (!_noneInternetView) {
        _noneInternetView = [[UIView alloc]init];
        _noneInternetView.backgroundColor = color_detail_background_f5f5f5;
        [self.view addSubview:_noneInternetView];
        
        [_noneInternetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(frame.origin.x);
            make.top.mas_equalTo(frame.origin.y);
            make.size.mas_equalTo(frame.size);
        }];
        UIImageView *fastIm = [[UIImageView alloc]init];
        fastIm.image = [UIImage imageNamed:@"icon_wifi_240"];
        [_noneInternetView addSubview:fastIm];
        [fastIm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noneInternetView);
            make.top.mas_equalTo(70);
            make.size.width.mas_equalTo(120);
            make.size.height.mas_equalTo(120);
        }];
        UILabel *lb = [[UILabel alloc] init];
        lb.text = @"暂无网络";
        lb.textColor= color_gray_a8a8a8;
        lb.font = [UIFont systemFontOfSize:18];
        lb.textAlignment = NSTextAlignmentCenter;
        [_noneInternetView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noneInternetView);
            make.top.equalTo(fastIm.mas_bottom).with.offset(30);
            make.left.equalTo(_noneInternetView.mas_left);
            make.right.equalTo(_noneInternetView.mas_right);
            make.height.equalTo(@18);
            
        }];
        
        UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn .backgroundColor = color_btn_eff7fc;
        btn.layer.cornerRadius= 2;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = color_line.CGColor;
        
        
        [btn setTitleColor:color_black3 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(reloadPage:) forControlEvents:UIControlEventTouchUpInside];
        [_noneInternetView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(_noneInternetView);
            make.top.equalTo(lb.mas_bottom).with.offset(20);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(35);
        }];
        
        self.reloadTouchBtn = reload;
        
        
    }
    _noneInternetView.frame = frame;
    [self.view bringSubviewToFront:_noneInternetView];
    [self.view bringSubviewToFront:self.navigationBar];
    _noneInternetView.hidden= NO;
}


-(void)removeNoneInterNetView{
    _noneInternetView.hidden = YES;
}


-(void)reloadPage:(UIButton *)sender{
    if (self.reloadTouchBtn) {
        self.reloadTouchBtn();
    }
    
}


#pragma mark - private methods
- (void)initDefaultStyle {
    self.bFirstAppear = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setFd_prefersNavigationBarHidden:)])
    {
        self.fd_prefersNavigationBarHidden = YES;
    }
    
    [self.navigationBar updateTitle:self.fyTitle?:@""];
    self.navigateStyle = kFYBaseVCNavigationStyleDefalut;
    self.navigationBar.delegate = self;
    self.view.backgroundColor = color_detail_background_f5f5f5;
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(NavigationHeight));
    }];
}

-(void)setHideNavigationBar:(Boolean)hideNavigationBar{
    if (_hideNavigationBar!=hideNavigationBar) {
        _hideNavigationBar = hideNavigationBar;
    }
    self.navigationBar.hidden = self.hideNavigationBar;
}


- (void)updateCustomInfo {
    NSString *title = self.fyTitle?:self.title;
    [self.navigationBar updateTitle:title?:@""];
    [self.navigationBar setBackButtonHidden:self.hideBackButton];
    self.navigationBar.hidden = self.hideNavigationBar;
}

- (void)refreshView {
}

- (void)setUpNaviationBarStyle{
  switch (self.navigateStyle) {
      case kFYBaseVCNavigationStyleRed:{
          NSArray<UIColor *> *gradientColors = @[color_btn_ff2c52,color_btn_ec4b39];
          UIColor *bgColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight
                                                   withFrame:CGRectMake(0, 0, ScreenWidth, NavigationHeight)
                                                   andColors:gradientColors];
          
          [self.navigationBar updateColor:bgColor];
          self.navigationBar.leftImageView.image = [UIImage imageNamed:@"back_white_36"];
          [self.navigationBar updateTitleColor:[UIColor whiteColor]];
      }
          break;
          
      case kFYBaseVCNavigationStyleBlack:{
          
          [self.navigationBar updateColor:color_black3];
          self.navigationBar.leftImageView.image = [UIImage imageNamed:@"back_white_36"];
          [self.navigationBar updateTitleColor:[UIColor whiteColor]];
      }
          break;
          
      default:{
          [self.navigationBar updateColor:[UIColor whiteColor]];
          self.navigationBar.leftImageView.image = [UIImage imageNamed:@"icon_b_back_36"];
          [self.navigationBar updateTitleColor:color_black3];
          [self.navigationBar updateLineColor:color_line_eeeeee];
      }
          break;
  }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark --getter setter
- (void)setNavigateStyle:(FYBaseVCNavigationStyle_t)navigateStyle{
    _navigateStyle = navigateStyle;
    [self setUpNaviationBarStyle];
}

- (UIView *)noDataPlaceholder{
    if (nil == _noDataPlaceholder) {
        _noDataPlaceholder = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                      self.view.width,
                                                                      self.view.height)];
        _noDataPlaceholder.backgroundColor = color_detail_background_f5f5f5;
        
        [_noDataPlaceholder addSubview:self.noDataImageView];
        [_noDataPlaceholder addSubview:self.noDatalabel];
        _noDataPlaceholder.hidden = YES;
    }
    return _noDataPlaceholder;
}

- (UIImageView *)noDataImageView{
    if (nil == _noDataImageView) {
        _noDataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        _noDataImageView.centerX = self.view.width * .5;
        _noDataImageView.bottom = self.view.height *.5 -15;
    }
    return _noDataImageView;
}

- (FYNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [FYNavigationBar naigationBarWithTitle:self.fyTitle?:@""];
    }
    return _navigationBar;
}

- (UILabel *)noDatalabel{
    if (nil == _noDatalabel) {
        _noDatalabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 18)];
        _noDatalabel.textAlignment = NSTextAlignmentCenter;
        _noDatalabel.textColor = color_gray_a8a8a8;
        _noDatalabel.top = self.noDataImageView.bottom + 15;
    }
    return _noDatalabel;
}

#pragma mark - FYNavigationBarDelegate
- (void)navigationBarBackButtonClick {
    [self backButtonAction];
}

#pragma mark - system
- (UIStatusBarStyle)preferredStatusBarStyle{
   return  (self.navigateStyle == kFYBaseVCNavigationStyleRed ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
}

-(void)setHiddenNavigatinBarSepLine:(BOOL)hiddenNavigatinBarSepLine{
    self.navigationBar.hiddenBottomSepLine = hiddenNavigatinBarSepLine;
}


#ifdef DEBUG
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{

    NSString * string = @"";
    
    string = @"FYMyCarViewController";
    string = @"FYLoginViewController";
    string = @"FYFinanceHomeVC";
    string = @"FYPayPolicyCreateVC";
    
    string = @"FYPayPolicyCreateSuccessVC";
    string = @"FYPayOrderViewController";
    string = @"FYLoginVerifyViewController";
    string = @"FYPayPolicyCreateVC";
    string = @"FYPayPolicyCreateSuccessVC";
//    FYBuyInsuranceView * view = [[FYBuyInsuranceView alloc] init];
//    [view show];
//
//    return;
    
    UIViewController * vc = [[NSClassFromString(string) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];


    
    
}
#endif
@end

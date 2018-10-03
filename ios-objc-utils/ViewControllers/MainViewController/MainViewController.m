//
//  MainViewController.m
//  ios-objc-utils
//
//  Created by OkuderaYuki on 2018/05/04.
//  Copyright © 2018年 OkuderaYuki. All rights reserved.
//

#import "MainViewController.h"
#import "APIClient.h"
#import "ItunesSearchAPI.h"
#import "UserInfoViewController.h"
#import "UIViewController+Validate4BytesCharacters.h"

@interface MainViewController () <ItunesSearchResult>

@property (nonatomic) ItunesSearchAPI *itunesSearchAPI;
@end

@implementation MainViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itunesSearchAPI = [[ItunesSearchAPI alloc] init];
    self.itunesSearchAPI.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

#pragma mark UIView+Gradation Usage

    UIColor * const whiteColor = UIColor.whiteColor;
    UIColor * const magentaColor = UIColor.magentaColor;
    [self.view gradationWithTopColor:whiteColor bottomColor:magentaColor];
}

#pragma mark - IBActions

- (IBAction)didTapShowAlertUsingBlock:(UIButton *)sender {
    [self showAlertCallbackBlock];
}

- (IBAction)didTapShowAlertUsingSelector:(UIButton *)sender {
    [self showAlertCallbackSelector];
}

- (IBAction)didTapGetRequest:(UIButton *)sender {

    [self.itunesSearchAPI loadWithTerm:@"テスト"];
}

- (IBAction)didTapPostImage:(UIButton *)sender {

    NSString * const urlString = @"https://httpbin.org/post";
    UIImage *testImage = [UIImage imageNamed:@"testImage"];
    NSDictionary *imageDataDic = @{ @"picture": UIImageJPEGRepresentation(testImage, 0) };

    [APIClient uploadImageWithUrlString:urlString
                             parameters:nil
                              imageData:imageDataDic
                                success:^(id responseObject) {
                                    DLOG(@"success!!!")
                                } failure:^(NSError *error) {
                                    DLOG(@"failure!!!")
                                    DLOG(@"error:%@", error)
                                }];
}

- (IBAction)didTapToNext:(UIButton *)sender {

    DLOG();

#pragma mark UIViewController+Storyboard Usage

    // Storyboard名を指定して、UserInfoViewControllerのインスタンスを生成
    NSString * const storyboardName = @"UserInfoViewController";
    UserInfoViewController *userInfoViewController = [UserInfoViewController initialViewControllerWithStoryboardName:storyboardName];

    [self.navigationController pushViewController:userInfoViewController animated:YES];
}

#pragma mark UIViewController+Alert Usage

- (void)showAlertCallbackBlock {

    NSString * const title = @"エラー";
    NSString * const message = @"ユーザIDが入力されていません。";
    [self singleButtonAlertWithTitle:title message:message handler:^(UIAlertAction *action) {
        DLOG(@"Block Callback");
    }];
}

- (void)showAlertCallbackSelector {

    NSString * const title = @"エラー";
    NSString * const message = @"パスワードが入力されていません。";
    [self singleButtonAlertWithTitle:title message:message selector:@selector(didTapOK)];
}

#pragma mark Selector method

- (void)didTapOK {
    DLOG(@"Selector Callback");
}

#pragma mark UIViewController+Validate4BytesCharacters Usage

- (IBAction)didTapRegister:(UIButton *)sender {

    UIAlertController *alert = [self validate4BytesCharacters];
    if (alert) {
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"4バイト文字の入力あり");
        return;
    }

    NSLog(@"4バイト文字の入力なし");
    // other validations
}

#pragma mark - ItunesSearchResult

- (void)itunesSearchResultSuccess:(ItunesSearchResponse *)response {
    DLOG(@"success!!!")
    DLOG(@"resultCount:%ld", (long)response.resultCount)
    DLOG(@"firstObject:%@", response.results.firstObject)
}

- (void)itunesSearchResultFailure:(NSString *)errorMessage {
    DLOG(@"failure!!!")
    DLOG(@"%@", errorMessage)
}

- (void)itunesSearchOffline:(NSString *)message {
    DLOG(@"offline!!!")
    DLOG(@"%@", message)
}
@end

#import "SSZipArchive.h"
#import "PubgLoad.h"
#import <UIKit/UIKit.h>
#include <JRMemory/MemScan.h>
#import "JHPP.h"
#import "JHDragView.h"
#import "SCLAlertView.h"
@interface PubgLoad()
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation PubgLoad

static PubgLoad *extraInfo;
static BOOL MenDeal;

+ (void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        extraInfo =  [PubgLoad new];
        [extraInfo initTapGes];
        [extraInfo tapIconView];
    });
}

-(void)initTapGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 2;//点击次数
    tap.numberOfTouchesRequired = 3;//手指数
    [[JHPP currentViewController].view addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(tapIconView)];
}

-(void)tapIconView
{
    JHDragView *view = [[JHPP currentViewController].view viewWithTag:100];
    if (!view) {
        view = [[JHDragView alloc] init];
        view.tag = 100;
        [[JHPP currentViewController].view addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onConsoleButtonTapped:)];
        tap.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tap];
        
    }
    
    if (!MenDeal) {
        view.hidden = NO;
    } else {
        view.hidden = YES;
    }
    
    MenDeal = !MenDeal;
}

-(void)onConsoleButtonTapped:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addTimerToButtonIndex:0 reverse:YES];
    
    //解析服务器版本
    NSError *error;
    NSString *txturl = [NSString stringWithFormat:@"https://iosgods.cn/html/game/zip.json"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:txturl]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //主标题
    NSString *gongneng1 = [json objectForKey:@"gongneng1"];//主功能
    NSString *quxiao = [json objectForKey:@"quxiao"];//主功能
    NSString *zhutitle = [json objectForKey:@"zhutitle"];
    NSString *fubiaoti = [json objectForKey:@"futitle"];
    
    [alert addButton:gongneng1 actionBlock:^{
    NSArray *zipzd =[[json objectForKey:@"zip"] componentsSeparatedByString:@","];
    NSArray *uzipzd =[[json objectForKey:@"uzip"] componentsSeparatedByString:@","];
    NSArray *diczd =[[json objectForKey:@"dic"] componentsSeparatedByString:@","];
    for (int i =0; i< diczd.count; i++) {
        if ([diczd[i] isEqual:@"Documents"]) {
            //Documents
            NSString *zip =zipzd[i];
            NSString *uzip =uzipzd[i];
            NSString *sourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:zip];
            NSString *targetPath = [[(NSArray *)NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:uzip];
            if([[NSFileManager defaultManager] fileExistsAtPath:sourcePath])
            {
            [SSZipArchive unzipFileAtPath:sourcePath toDestination:targetPath delegate:self];
            }else
            {
            }
        }
        if ([diczd[i] isEqual:@"Library"]) {
            //Library
            NSString *zip =zipzd[i];
            NSString *uzip =uzipzd[i];
            NSString *sourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:zip];
            NSString *targetPath = [[(NSArray *)NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:uzip];
            if([[NSFileManager defaultManager] fileExistsAtPath:sourcePath])
            {
            [SSZipArchive unzipFileAtPath:sourcePath toDestination:targetPath delegate:self];
            }else
            {
            }
        }
    }
   
    }];

    
    [alert showSuccess:zhutitle subTitle:fubiaoti closeButtonTitle:quxiao duration:nil];
    
    
}



@end

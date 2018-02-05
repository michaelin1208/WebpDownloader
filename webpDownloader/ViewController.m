//
//  ViewController.m
//  webpDownloader
//
//  Created by Michaelin on 2017/10/18.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "YYImage.h"
#import "WebpTableViewCell.h"
#import "YYImageWithLoopCount.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *webPTableView;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (strong, nonatomic) NSMutableDictionary *webPs;
@end

@implementation ViewController {
    NSMutableDictionary *webPAddresses;
    NSString *index;
    NSString *address;
    NSString *eName;
    int downloadTimes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.webPs = app.webPs;
    
    self.webPTableView.dataSource = self;
    self.webPTableView.delegate = self;
    
//    NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:@"http://sportgame.955uc.com/michaelin/webps.xml" ofType:nil];
    [self updateWebpAddress];
    
}

- (void)viewDidAppear:(BOOL)animated {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新" message:[NSString stringWithFormat:@"更新次数:%d",downloadTimes] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateWebpAddress {
    NSData *xmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://sportgame.955uc.com/michaelin/webps.xml"]];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    xmlParser.delegate = self;
    
    //  开始解析
    [xmlParser parse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cleanBtnClicked:(id)sender {
    NSLog(@"cleanBtnClicked");
    [self.webPs removeAllObjects];
    [self.webPTableView reloadData];
}

- (IBAction)refreshBtnClicked:(id)sender {
    NSLog(@"refreshBtnClicked");
    [self.webPs removeAllObjects];
    [self.webPTableView reloadData];
    [self updateWebpAddress];
}

- (void)checkWebpsDictionary {
    downloadTimes = 0;
    NSDictionary *oldWebps = [self.webPs copy];
    [self.webPs removeAllObjects];
    self.webPs = [NSMutableDictionary dictionary];
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.webPs = self.webPs;
    for (NSString *key in webPAddresses.allKeys) {
        if ([oldWebps.allKeys containsObject:key]) {
            [self.webPs setObject:[oldWebps objectForKey:key] forKey:key];
            [self.webPTableView reloadData];
        }else{
            downloadTimes++;
            // 1. 创建url
            NSString *urlString = [webPAddresses objectForKey:key];
            urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *url = [NSURL URLWithString:urlString];
            // 2. 创建请求
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            // 3. 创建会话 (使用单例初始化, 启动任务)
            
            NSURLSession *session = [NSURLSession sharedSession];
            
            // 会话创建任务
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (!error) {
                    [self.webPs setObject:data forKey:key];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.webPTableView reloadData];
                    });
                } else {
                    NSLog(@"error is %@", error.localizedDescription);
                }
                
            }];
            
            // 恢复线程, 启动任务
            [dataTask resume];
        }
    }
}

#pragma marks - UITableView delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.webPs.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"tablecell";
    
    WebpTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WebpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        YYAnimatedImageView *yyImageView = [[YYAnimatedImageView alloc] initWithFrame:cell.imageView.frame];
    }
    
    if (indexPath.row < self.webPs.count){
        NSString *webpId = self.webPs.allKeys[indexPath.row];
//        NSString *name = [self.webPs objectForKey:webpId];
//        NSRange range = [name rangeOfString:@"[a-zA-Z]+.webp" options:NSRegularExpressionSearch];
//        if (range.location != NSNotFound) {
//            name = [name substringWithRange:range];
//        }
        cell.webpNameLabel.text = webpId;
        cell.webpImageView.image = (YYImageWithLoopCount *)[YYImageWithLoopCount imageWithData:[self.webPs objectForKey:webpId]];
        
        NSLog(@"id: %@",webpId);
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma marks - NSXMLParserDelegate

// 开始
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
    NSLog(@"开始");
    
    webPAddresses = [NSMutableDictionary dictionary];
    
}

// 获取节点头
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
//    if (elementName isEqualToString:@"") {
//        <#statements#>
//    }
    NSLog(@"elementName: %@",elementName);
    eName = elementName;
}

// 获取节点的值 (这个方法在获取到节点头和节点尾后，会分别调用一次)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSLog(string);
    if (eName != nil) {
        if ([eName isEqualToString:@"index"]) {
            index = string;
        }else if ([eName isEqualToString:@"address"]){
            address = string;
        }
    }
}

// 获取节点尾
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"webp"]) {
        [webPAddresses setObject:address forKey:index];
        address = nil;
        index = nil;
    }
    eName = nil;
}

// 结束
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    NSLog(@"结束");
    NSLog(@"%@",webPAddresses);
    
    [self checkWebpsDictionary];
}

@end



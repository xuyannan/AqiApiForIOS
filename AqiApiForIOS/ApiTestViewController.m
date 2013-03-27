//
//  ApiTestViewController.m
//  AqiApiForIOS
//
//  Created by xu yannan on 13-3-25.
//  Copyright (c) 2013年 BLUETIGER. All rights reserved.
//

#import "ApiTestViewController.h"
#import "AqiAPI.h"

#define APPKEY @"QfEJyi3oWKSBCnKrqp1v"

@interface ApiTestViewController ()

@end

@implementation ApiTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // test code for AqiAPI
    AqiAPI *api = [[AqiAPI alloc]initWithAppkey:APPKEY ];
    NSArray *data = [api getChineseAqiDataForCity:@"北京"];
    NSLog(@"%@", data);
    
    NSArray *usemData = [api getUsemAqiDataForCity: @"北京"];
    NSLog(@"%@", usemData);
    
    NSArray *cities = [api supportedCities];
    for (NSString *city in cities) {
        NSLog(@"%@", city);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  InputStudentInfoController.m
//  Sqlite3Demo
//
//  Created by George.tan on 2018/1/22.
//  Copyright © 2018年 huawei. All rights reserved.
//

#import "InputStudentInfoController.h"
#import "DataBaseManager.h"
#import "Student.h"
#import "StudentTableController.h"

@interface InputStudentInfoController ()
@property (weak, nonatomic) IBOutlet UITextField *IdTxField;
@property (weak, nonatomic) IBOutlet UITextField *NameTxField;
@property (weak, nonatomic) IBOutlet UITextField *SexTxField;
@property (weak, nonatomic) IBOutlet UITextField *AgeTxField;
@property (weak, nonatomic) IBOutlet UITextField *PhotoTxField;

@end

@implementation InputStudentInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)inputDataAction:(UIButton *)sender {
    if (_IdTxField.text.length <= 0 || _NameTxField.text.length <= 0 || _SexTxField.text.length <= 0 && _AgeTxField.text.length <= 0 || _PhotoTxField.text.length <= 0) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"请将信息填写完整" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:cancel];
        [self presentViewController:alertVc animated:YES completion:nil];
        return;
    }
    
    Student *stu = [[Student alloc] init];
    stu.ID = [_IdTxField.text intValue];
    stu.name = _NameTxField.text;
    stu.age = [_AgeTxField.text intValue];
    stu.sex = _AgeTxField.text;
    stu.photo = nil;
    
    BOOL insert = [[DataBaseManager shareInstace] inserSingleData:stu];
    if (insert) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            StudentTableController *stuVc = [[StudentTableController alloc] init];
            [self.navigationController pushViewController:stuVc animated:YES];
        }];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"插入成功!" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:cancel];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else{
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"插入失败!" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:cancel];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

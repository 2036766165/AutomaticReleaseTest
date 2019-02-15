//
//  BulletManager.m
//  CommentDemo
//
//  Created by feng jia on 16/2/20.
//  Copyright © 2016年 caishi. All rights reserved.
//

#import "WKBulletManager.h"
#import "WKBulletView.h"
#import "WKBarrageModel.h"

@interface WKBulletManager()
@property (nonatomic, strong) NSMutableArray *tmpComments;
@property (nonatomic, strong) NSMutableArray *bulletQueue;
@property (nonatomic, strong) NSMutableArray *whichBullet;

@property BOOL bStarted;
@property BOOL bStopAnimation;

@end

@implementation WKBulletManager
- (void)start {
    self.bStarted = YES;
    self.whichBullet = [NSMutableArray new];
    self.tmpComments = [NSMutableArray new];
    self.bStopAnimation = NO;
    [self initBulletCommentView];
    
}

- (void)stop {
    self.bStopAnimation = YES;
    [self.bulletQueue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WKBulletView *view = obj;
        [view stopAnimation];
        [self.tmpComments removeAllObjects];
        view = nil;
    }];
}

#pragma mark - Private
/**
 *  创建弹幕
 *  @param comment    弹幕内容
 *  @param trajectory 弹道位置
 */
- (void)createBulletComment:(WKBarrageModel *)comment trajectory:(Trajectory)trajectory {
    if (self.bStopAnimation) {
        return;
    }
    //创建一个弹幕view
    WKBulletView *view = [[WKBulletView alloc] initWithContent:comment];
    //设置运行轨迹
    view.trajectory = trajectory;
    __weak WKBulletView *weakBulletView = view;
    __weak WKBulletManager *myself = self;
    /**
     *  弹幕view的动画过程中的回调状态
     *  Start:创建弹幕在进入屏幕之前
     *  Enter:弹幕完全进入屏幕
     *  End:弹幕飞出屏幕后
     */
    
    view.moveBlock = ^(CommentMoveStatus status) {
        if (myself.bStopAnimation) {
            return ;
        }
        switch (status) {
            case Start:
                //弹幕开始……将view加入弹幕管理queue
                [self.bulletQueue addObject:weakBulletView];
                break;
            case Enter: {
                //弹幕完全进入屏幕，判断接下来是否还有内容，如果有则在该弹道轨迹对列中创建弹幕……
                WKBarrageModel *model = [myself nextComment];
                if (model) {
                    [myself createBulletComment:model trajectory:trajectory];
                } else {
                    //说明到了评论的结尾了
                    [self.whichBullet addObject:@(trajectory)];
                }
                break;
            }
            case End: {
                //弹幕飞出屏幕后从弹幕管理queue中删除
                if ([myself.bulletQueue containsObject:weakBulletView]) {
                    [myself.bulletQueue removeObject:weakBulletView];
                }
                if (myself.bulletQueue.count == 0) {
                    //说明屏幕上已经没有弹幕评论了，循环开始
//                    [myself start];
                }
                break;
            }
            default:
                break;
        }
    };
    //弹幕生成后，传到viewcontroller进行页面展示
    if (self.generateBulletBlock) {
        self.generateBulletBlock(view);
    }
}
/**
 *  初始化弹幕
 */
- (void)initBulletCommentView {
    //初始化三条弹幕轨迹
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@(2), @(1), @(0)]];
    for (int i = 3; i > 0; i--) {
        WKBarrageModel *model = [self.tmpComments firstObject];
        if (model) {
            [self.tmpComments removeObjectAtIndex:0];
            //随机生成弹道创建弹幕进行展示（弹幕的随机飞入效果）
            NSInteger index = [arr[0] integerValue];
            Trajectory trajectory = [[arr objectAtIndex:index] intValue];
            [arr removeObjectAtIndex:index];
            [self createBulletComment:model trajectory:trajectory];
        } else {
            //当弹幕小于三个，则跳出
            [self.whichBullet addObjectsFromArray:arr];
            break;
        }
    }
}

-(void)insertBullet:(WKBarrageModel *)model{
    if (self.whichBullet.count>0) {
        [self createBulletComment:model trajectory:[self.whichBullet[0] integerValue]];
        [self.whichBullet removeObjectAtIndex:0];
    }else{
        [self.tmpComments addObject:model];
    }
}

- (WKBarrageModel *)nextComment {
    WKBarrageModel *model = [self.tmpComments firstObject];
    if (model) {
        [self.tmpComments removeObjectAtIndex:0];
    }
    return model;
}

#pragma mark - Getter

- (NSMutableArray *)tmpComments {
    if (!_tmpComments) {
        _tmpComments = [NSMutableArray array];
    }
    return _tmpComments;
}

- (NSMutableArray *)bulletQueue {
    if (!_bulletQueue) {
        _bulletQueue = [NSMutableArray array];
    }
    return _bulletQueue;
}

@end

//
//  CommonConfig.h
//  SmarkPark
//
//  Created by Dwt on 2018/5/25.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#ifndef CommonConfig_h
#define CommonConfig_h

#define AppScheme @"37dugongyu"
//微信
#define WeixinAppid @"wxc1be2bd3f8f58fba"
#define WeixinSecret @"d51c0f5b52cffc3bb9a58fb3e736f9f2"
#define WeixinGetUserInfoToken @"https://api.weixin.qq.com/sns/oauth2/access_token"//获取微信用户信息token
#define WeixinGetUserInfo @"https://api.weixin.qq.com/sns/userinfo"//获取微信用户信息
//加密
#define MD5String @"dxtk"//获取微信用户信息
#define MD5Header @"qwe"//获取微信用户信息


#define QQAppid @"1106175575"
#define UMengAppid @"5b0e06fdb27b0a398200002a" //分享
#define ShareUrl @"api/index/share" //分享
#define AMAP_KEY @"e3d425bdb69120ff00ca6ed7e27fc792" //高德

//统一配置
#define CollectionUrl @"collection/edit"//收藏
#define InquiryCollectionUrl @"collection/status"//查询收藏状态
#define PictureUploadAllUrl @"upload/uploadMore"//多张图片上传
#define PictureUploadUrl @"upload/uploadByType"//单张图片上传
#define HtmlDetailUrl @"Public/article/id/"//获取文章h5
//首页banner
#define HomeBannerUrl @"public/getArticleByCat"//轮播图

//登录
#define LoginUrl @"login/login"
#define LogOutUrl @"login/logout"//退出登录
#define ChangePasswordUrl @"User/changePassword"//修改密码
#define ChangeAvatarUrl @"User/changeAvatar"//修改头像
#define UserGetInfoByTokenUrl @"user/getSimpleInfo"//获取用户信息

//消息
#define NoReadMessageUrl @"message/getReadMessage"//是否有未读消息
#define NewsListUrl @"message/index"//列表
#define NewsDeleteUrl @"message/delete"//删除
#define NewsHaveReadUrl @"message/read"//已读
#define NewsDetailUrl @"message/details?id="//消息详情
#define NewsHtmlDetailUrl @"message/details/id/"//获取消息文章h5

//作业
#define OperationStuGroupListUrl @"Workteacher/workGroup"//学生组列表
#define OperationAddStuGroupListUrl @"Workteacher/getStudents"//添加学生组列表
#define OperationAddStuGroupDetailUrl @"Workteacher/workGroupDetails"//学生组详情
#define OperationAddStuGroupUrl @"Workteacher/addWorkGroup"//添加学生组
#define OperationEditStuGroupUrl @"Workteacher/editWorkGroup"//编辑学生组
#define OperationDeleteStuGroupUrl @"Workteacher/deleteWorkGroup"//学生组解散
#define OperationSubmitUrl @"Workteacher/saveWork"//发布/保存作业
#define OperationEditSubmitUrl @"Workteacher/editWork"//编辑作业接口
#define OperationInsListUrl @"Workteacher/getWorks"//学管员作业列表
#define OperationInsDetailUrl @"Workteacher/workDetails"//学管员未送达作业详情
#define OperationInsDeleteUrl @"Workteacher/deleteWork"//学管员删除作业接口
#define OperationStuNowListUrl @"Work/index"//学管员作业列表
#define OperationStuHistoryListUrl @"Work/getLogWorks"//学管员作业列表
#define OperationStuDetailUrl @"Work/details"//学生作业详情
#define OperationStuSubmitUrl @"Work/complete"//学生打卡
#define OperationStuLookUrl @"Work/classmateWork"//学生查看同学
#define OperationStatisticsUrl @"work/statistics"//学生统计页面
#define OperationInsHistoryListUrl @"Workteacher/getLogWorks"//学管作业统计列表统计页面
#define OperationInsHistoryUrl @"Workteacher/getLogRate"//学管作业统计页面
#define OperationInsPublishDetailUrl @"Workteacher/logWorkDetails"//学管已发布详情
#define OperationInsPublishListUrl @"Workteacher/logWorkStudents"//学管员已发布作业详情学生列表
#define OperationInsReminderUrl @"Workteacher/clockWork"//学管员提醒打卡
#define OperationInsStuDetailUrl @"Workteacher/studentWorkDetails"//学管员查看学生作业详情
#define OperationInsCommentUrl @"Workteacher/comment"//学管员评价

//答疑
#define AnswerSubjectsUrl @"public/getSubjects"//获取科目
#define AnswerSubjectTeacherUrl @"question/getTeachersBySubjectId"//获取科目老师
#define AnswerSubmitUrl @"question/ask"//提问
#define AnswerReplySubmitUrl @"question/answer"//学生回复
#define AnswerMyListUrl @"question/index"//答疑列表
#define AnswerMyDetailUrl @"question/details"//答疑详情
#define AnswerTeacherListUrl @"questionteacher/index"// 老师答疑列表
#define AnswerTeacherSubmitUrl @"questionteacher/answer"//老师回复
#define AnswerTeacherStatisticsUrl @"questionteacher/statistics"//老师统计


//积分
#define IntegralOptionUrl @"score/getScoreSelect"//区域选项
#define IntegralRankUrl @"score/rank"//积分排行榜
#define IntegralMyRankUrl @"score/selfRank"//积分排行榜
#define IntegralRecordUrl @"Score/scoreLogs"//积分排行榜
#define IntegralStuSubmitUrl @"score/addScoreApply"//学生申请补分
#define IntegralTeaListUrl @"Scoreteacher/scoreApply"//补分审批列表
#define IntegralTeaDeleteUrl @"Scoreteacher/scoreApplyDelete"//补分审批删除
#define IntegralTeaDetailUrl @"Scoreteacher/scoreApplyCheckDetails"//补分审批详情
#define IntegralTeaSubmitUrl @"Scoreteacher/scoreApplyCheck"//老师补分审批


//考勤
#define AttendanceListUrl @"attendance/lst"//考勤组列表
#define AttendanceDetailUrl @"attendance/info"//考勤组详情
#define AttendanceDisbandUrl @"attendance/del"//考勤组解散
#define AttendanceGetStuUrl @"attendance/stulist"//获取所管理的学生列表
#define AttendanceAddUrl @"attendance/add"//新建考勤组
#define AttendancEditUrl @"attendance/edit"//编辑考勤组
#define AttendancSignInUrl @"attendance/sign_in"//签到
#define AttendancSignOutUrl @"attendance/sign_out"//签退
#define AttendanceAllListUrl @"attendance/statistics_lst"//考勤组统计列表
#define AttendancStuStaUrl @"attendance/statistics"//查询考勤情况

//请假
#define LeaveStuCategoryUrl @"leave/getLeaveCategory"//学生获取请假类型
#define LeaveStuSubmitUrl @"leave/leaveApply"//学生请假提交
#define LeaveStuListUrl @"leave/index"//学生请假列表
#define LeaveDetailUrl @"leave/details"//请假申请详情
#define LeaveReplyListUrl @"leave/getNewAnswers"//请假详情回复列表
#define LeaveStuDeleteUrl @"leave/delete"//学生请假信息删除
#define LeaveInsDeleteUrl @"Leaveteacher/delete"//学管请假信息删除
#define LeaveInsListUrl @"Leaveteacher/index"//学管请假列表
#define LeaveInsHistoryUrl @"leaveteacher/getStudentLeaves"//请假历史列表
#define LeaveInsApprovaltUrl @"leaveteacher/leaveCheck"//学管员审核接口
#define LeaveInsChangeUrl @"leaveteacher/changeLeaveStatus"//更改审核状态
#define LeaveInsReplySubmitUrl @"leave/answer"//回复

#pragma mark  成绩
#define GradeCategoryUrl @"grade/exam_type_list"//获取考试类型列表
#define GradeEmaxUrl @"grade/exam_list"//获取考试类列表
#define GradeAddUrl @"grade/add"//添加成绩单
#define GradeEditUrl @"grade/edit"//修改成绩单
#define GradeReleaseUrl @"grade/issue"//发布成绩单
#define GradeInsListUrl @"grade/lst"//获取成绩单列表
#define GradeInsDetailUrl @"grade/info"//获取成绩单信息
#define GradeStuListUrl @"grade/lst"//学生获取成绩单列表
#define GradeStuDetailUrl @"grade/info"//学生获取成绩详情
#define GradeInsStatisUrl @"grade/statistics"//学管员成绩分析
#define GradeInsLookStuStatisUrl @"grade/statistics"//查看学员成绩分析
#define GradeInsLookStuUrl @"grade/stu_list"//查看学员
#define GradeInsSetRoleSetRoleUrl @"grade/honor"//设为榜样 光荣榜


#pragma mark  我的班级
#define InsClassListUrl @"class/lst"//获取我的班级列表
#define InsClassStudtentUrl @"class/stu_list"//我的班级学生列表
#define InsClassSubjectUrl @"class/subject_list"//获取科目列表（我的班级专用）
#define InsClassSubmitUrl @"class/add_stu"//添加学生
#define InsClassEditStuUrl @"class/edit_stu"//修改学生信息
#define InsClassStuInfoUrl @"class/stu_info"//学管员获取我的班级的学生信息
#define InsClassDeleteUrl @"class/del_stu"//删除学生
// 服务器API

//#define SERVER_IP @"http://192.168.2.107:9888"
#ifdef DEBUG //测试阶段
#define SERVER_IP @"http://duxue.test2.yikeapp.cn/api/"

#else
#define SERVER_IP @"http://duxue.test2.yikeapp.cn/api/"

#endif

#endif /* CommonConfig_h */

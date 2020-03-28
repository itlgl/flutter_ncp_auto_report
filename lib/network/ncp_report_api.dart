import 'package:dio/dio.dart';
import 'package:ncpautoreport/network/ncp_report_bean.dart';
import 'dart:convert' show json;
import 'package:date_format/date_format.dart' as date_format;

class NcpReportApi {
  static Dio dio = Dio();

  Future<NcpResultBean> ncpReport(NcpReportBean bean) async {
    var response = await dio.post(
        'http://es.hbgf.net.cn:9004/form/info/collect',
        data: json.encode(bean),
        options: Options(
            contentType: 'application/json', responseType: ResponseType.json));
    print(response);
    return NcpResultBean.fromJson(response.data);
  }

  Future<NcpInfoBean> getNcpInfo() async {
    var response =
        await dio.get('http://es.hbgf.net.cn:9004/form/info/department');
    //print('response=${response.data}');
    NcpInfoBean bean = NcpInfoBean.fromJson(response.data);
    print('bean=$bean');
    if(bean == null) {
      return Future.error('bean is null');
    }
    return bean;
  }

  Future<NcpResultBean> reportForLigl() {
    var dateTimeNow = DateTime.now();
    var reportDate = date_format.formatDate(dateTimeNow,
        [date_format.yyyy, '-', date_format.mm, '-', date_format.dd]);
    var yesterdayTrail = dateTimeNow.weekday == DateTime.tuesday ||
            dateTimeNow.weekday == DateTime.wednesday
        ? '上班'
        : '在家';
    NcpReportBean bean = NcpReportBean.fromParams(
        reportDate: reportDate,
        staffName: '李冠良',
        departmentId: 2,
        subDepartment: '数字资产PU',
        mobile: '',
        symptomsOne: 0,
        symptomsOneFamily: 0,
        contactWuhan: 0,
        addressPresent: '北京石景山',
        attentionFlag: 0,
        attentionInfo: '',
        workTraffic: '公共交通',
        yesterdayTrail: yesterdayTrail,
        livingFamilyTrail: '在家');
    return ncpReport(bean);
  }
}

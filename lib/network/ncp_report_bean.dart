import 'dart:convert' show json;

class NcpInfoBean {
  int code;
  String msg;
  List<NcpInfoData> data;

  NcpInfoBean.fromParams({this.code, this.msg, this.data});

  factory NcpInfoBean(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new NcpInfoBean.fromJson(json.decode(jsonStr))
          : new NcpInfoBean.fromJson(jsonStr);

  NcpInfoBean.fromJson(jsonRes) {
    if(jsonRes == null) {
      return;
    }
    if(jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }

    code = jsonRes['code'];
    msg = jsonRes['msg'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']) {
      data.add(dataItem == null ? null : new NcpInfoData.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"code": $code,"msg": ${msg != null ? '${json.encode(msg)}' : 'null'},"data": $data}';
  }
}

class NcpInfoData {
  int departmentId;
  String departmentName;
  List<dynamic> subDepartmentNameList;

  NcpInfoData.fromParams(
      {this.departmentId, this.departmentName, this.subDepartmentNameList});

  NcpInfoData.fromJson(jsonRes) {
    if(jsonRes == null) {
      return;
    }
    if(jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }

    departmentId = jsonRes['departmentId'];
    departmentName = jsonRes['departmentName'];
    subDepartmentNameList =
        jsonRes['subDepartmentNameList'] == null ? null : [];

    for (var subDepartmentNameListItem in subDepartmentNameList == null
        ? []
        : jsonRes['subDepartmentNameList']) {
      subDepartmentNameList.add(subDepartmentNameListItem);
    }
  }

  @override
  String toString() {
    return '{"departmentId": $departmentId,"departmentName": ${departmentName != null ? '${json.encode(departmentName)}' : 'null'},"subDepartmentNameList": $subDepartmentNameList}';
  }
}

class NcpReportBean {
  int attentionFlag;
  int contactWuhan;
  int departmentId;
  int symptomsOne;
  int symptomsOneFamily;
  String addressPresent;
  String attentionInfo;
  String livingFamilyTrail;
  String mobile;
  String reportDate;
  String staffName;
  String subDepartment;
  String workTraffic;
  String yesterdayTrail;

  NcpReportBean.fromParams(
      {this.attentionFlag,
      this.contactWuhan,
      this.departmentId,
      this.symptomsOne,
      this.symptomsOneFamily,
      this.addressPresent,
      this.attentionInfo,
      this.livingFamilyTrail,
      this.mobile,
      this.reportDate,
      this.staffName,
      this.subDepartment,
      this.workTraffic,
      this.yesterdayTrail});

  factory NcpReportBean(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new NcpReportBean.fromJson(json.decode(jsonStr))
          : new NcpReportBean.fromJson(jsonStr);

  NcpReportBean.fromJson(jsonRes) {
    if(jsonRes == null) {
      return;
    }
    if(jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }

    attentionFlag = jsonRes['attentionFlag'];
    contactWuhan = jsonRes['contactWuhan'];
    departmentId = jsonRes['departmentId'];
    symptomsOne = jsonRes['symptomsOne'];
    symptomsOneFamily = jsonRes['symptomsOneFamily'];
    addressPresent = jsonRes['addressPresent'];
    attentionInfo = jsonRes['attentionInfo'];
    livingFamilyTrail = jsonRes['livingFamilyTrail'];
    mobile = jsonRes['mobile'];
    reportDate = jsonRes['reportDate'];
    staffName = jsonRes['staffName'];
    subDepartment = jsonRes['subDepartment'];
    workTraffic = jsonRes['workTraffic'];
    yesterdayTrail = jsonRes['yesterdayTrail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reportDate'] = this.reportDate;
    data['staffName'] = this.staffName;
    data['departmentId'] = this.departmentId;
    data['subDepartment'] = this.subDepartment;
    data['mobile'] = this.mobile;
    data['symptomsOne'] = this.symptomsOne;
    data['symptomsOneFamily'] = this.symptomsOneFamily;
    data['contactWuhan'] = this.contactWuhan;
    data['addressPresent'] = this.addressPresent;
    data['attentionFlag'] = this.attentionFlag;
    data['attentionInfo'] = this.attentionInfo;
    data['workTraffic'] = this.workTraffic;
    data['yesterdayTrail'] = this.yesterdayTrail;
    data['livingFamilyTrail'] = this.livingFamilyTrail;
    return data;
  }

  @override
  String toString() {
    return '{"attentionFlag": $attentionFlag,"contactWuhan": $contactWuhan,"departmentId": $departmentId,"symptomsOne": $symptomsOne,"symptomsOneFamily": $symptomsOneFamily,"addressPresent": ${addressPresent != null ? '${json.encode(addressPresent)}' : 'null'},"attentionInfo": ${attentionInfo != null ? '${json.encode(attentionInfo)}' : 'null'},"livingFamilyTrail": ${livingFamilyTrail != null ? '${json.encode(livingFamilyTrail)}' : 'null'},"mobile": ${mobile != null ? '${json.encode(mobile)}' : 'null'},"reportDate": ${reportDate != null ? '${json.encode(reportDate)}' : 'null'},"staffName": ${staffName != null ? '${json.encode(staffName)}' : 'null'},"subDepartment": ${subDepartment != null ? '${json.encode(subDepartment)}' : 'null'},"workTraffic": ${workTraffic != null ? '${json.encode(workTraffic)}' : 'null'},"yesterdayTrail": ${yesterdayTrail != null ? '${json.encode(yesterdayTrail)}' : 'null'}}';
  }
}

class NcpResultBean {
  String msg;
  int code;

  NcpResultBean({this.msg, this.code});

  NcpResultBean.fromJson(jsonStr) {
    if(jsonStr == null) {
      return;
    }
    if(jsonStr is String) {
      jsonStr = json.decode(jsonStr);
    }
    msg = jsonStr['msg'];
    code = jsonStr['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    return data;
  }
}
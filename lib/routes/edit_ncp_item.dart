import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ncpautoreport/network/ncp_report_api.dart';
import 'package:ncpautoreport/network/ncp_report_bean.dart';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNcpItemRoute extends StatefulWidget {
  NcpInfoBean _ncpInfoBean;
  Object _error;

  @override
  State<StatefulWidget> createState() {
    return _EditNcpItemState();
  }
}

class _EditNcpItemState extends State<EditNcpItemRoute> {
  GlobalKey<_NcpItemState> ncpItemViewKey = GlobalKey<_NcpItemState>();

  @override
  Widget build(BuildContext context) {
    var arguments2 = ModalRoute.of(context).settings.arguments;
    print('arguments2=$arguments2');
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Center(
                child: Text('上报信息'),
              ),
            ),
            onTap: () {
              var fromState = ncpItemViewKey.currentState.widget.formKey.currentState;
              if(fromState.validate()) {
                fromState.save();
                ncpItemViewKey.currentState.widget.saveFormValueToCache();
              }
            },
          ),
        ],
      ),
      body: ncpBodyView(),
    );
  }

  @override
  void initState() {
    super.initState();

    initNcpReportBean();
  }

  void initNcpReportBean() {
    setState(() {
      widget._ncpInfoBean = null;
      widget._error = null;
    });
    NcpReportApi().getNcpInfo().then((value) {
      setState(() {
        widget._ncpInfoBean = value;
        widget._error = null;
      });
    }, onError: (e, stack) {
      setState(() {
        widget._ncpInfoBean = null;
        widget._error = e;
      });
    });
  }

  Widget ncpBodyView() {
    if (widget._ncpInfoBean != null) {
      return Container(
        color: Colors.white,
        child: _NcpItemView(
          widget._ncpInfoBean,
          key: ncpItemViewKey,
        ),
      );
    } else if (widget._error != null) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            initNcpReportBean();
          },
          child: Center(
            child: Text('网络错误，点击重试...'),
          ),
        ),
      );
    }
  }
}

class _NcpItemView extends StatefulWidget {
  NcpInfoBean _ncpInfoBean;

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String reportDate;
  String staffName,
      subDepartment,
      mobile,
      addressPresent,
      attentionInfo,
      workTraffic = '公共交通';
  int departmentId,
      symptomsOne = 0,
      symptomsOneFamily = 0,
      contactWuhan = 0,
      attentionFlag = 0;

  Set<String> yesterdayTrailSet = Set<String>();
  Set<String> livingFamilyTrailSet = Set<String>();

  NcpReportBean ncpReportBean() {
    return NcpReportBean.fromParams(
      reportDate: reportDate,
      staffName: staffName,
      departmentId: departmentId,
      subDepartment: subDepartment,
      mobile: mobile,
      symptomsOne: symptomsOne,
      symptomsOneFamily: symptomsOneFamily,
      contactWuhan: contactWuhan,
      addressPresent: addressPresent,
      attentionFlag: attentionFlag,
      attentionInfo: attentionInfo,
      workTraffic: workTraffic,
      yesterdayTrail: yesterdayTrail(),
      livingFamilyTrail: livingFamilyTrail(),
    );
  }

  String yesterdayTrail() {
    var result = '';
    if (yesterdayTrailSet == null || yesterdayTrailSet.length == 0) {
      return result;
    }
    for (var s in yesterdayTrailSet) {
      if (result == '') {
        result += s;
      } else {
        result += ',' + s;
      }
    }
    return result;
  }

  String livingFamilyTrail() {
    var result = '';
    if (livingFamilyTrailSet == null || livingFamilyTrailSet.length == 0) {
      return result;
    }
    for (var s in livingFamilyTrailSet) {
      if (result == '') {
        result += s;
      } else {
        result += ',' + s;
      }
    }
    return result;
  }

  _NcpItemView(this._ncpInfoBean, {Key key}) : super(key: key) {
    initFormValueFromCache();
  }

  @override
  State<StatefulWidget> createState() {
    return _NcpItemState();
  }

  void initFormValueFromCache() async {
    print('asdfasdfasdf');
    SharedPreferences sp = await SharedPreferences.getInstance();
    staffName = sp.getString('staffName');
    departmentId = sp.getInt('departmentId');
    subDepartment = sp.getString('subDepartment');
    mobile = sp.getString('mobile');
    symptomsOne = sp.getInt('symptomsOne');
    symptomsOneFamily = sp.getInt('symptomsOneFamily');
    contactWuhan = sp.getInt('contactWuhan');
    addressPresent = sp.getString('addressPresent');
    attentionFlag = sp.getInt('attentionFlag');
    attentionInfo = sp.getString('attentionInfo');
    workTraffic = sp.getString('workTraffic');
    yesterdayTrailSet.clear();
    var tem = sp.getString('yesterdayTrail')?.split(',')?.toSet();
    if (tem != null) {
      yesterdayTrailSet.addAll(tem);
    }
    livingFamilyTrailSet.clear();
    tem = sp.getString('livingFamilyTrail')?.split(',')?.toSet();
    if (tem != null) {
      livingFamilyTrailSet.addAll(tem);
    }


  }

  void saveFormValueToCache() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('staffName', staffName);
    sp.setInt('departmentId', departmentId);
    sp.setString('subDepartment', subDepartment);
    sp.setString('mobile', mobile);
    sp.setInt('symptomsOne', symptomsOne);
    sp.setInt('symptomsOneFamily', symptomsOneFamily);
    sp.setInt('contactWuhan', contactWuhan);
    sp.setString('addressPresent', addressPresent);
    sp.setInt('attentionFlag', attentionFlag);
    sp.setString('attentionInfo', attentionInfo);
    sp.setString('workTraffic', workTraffic);
    sp.setString('yesterdayTrail', yesterdayTrail());
    sp.setString('livingFamilyTrail', livingFamilyTrail());
  }
}

class _NcpItemState extends State<_NcpItemView> {
  static RegExp dateRegExp = RegExp(r'^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          autovalidate: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '*填报日期'),
                enabled: false,
//              validator: (value) {
//                return dateRegExp.firstMatch(value) != null ? null : '填报日期应该是2020-1-1的格式';
//              },
                initialValue:
                    formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '*用户名'),
                validator: (value) {
                  return value.trim().length > 0 ? null : '用户名不能为空';
                },
                onSaved: (value) {
                  widget.staffName = value;
                },
              ),
              DropdownButtonFormField<int>(
                value: widget.departmentId,
                decoration: InputDecoration(labelText: '*选择您的部门'),
                items: widget._ncpInfoBean?.data?.map((e) {
                  return DropdownMenuItem(
                    child: Text(e.departmentName),
                    value: e.departmentId,
                  );
                })?.toList(),
                onChanged: (value) {
                  setState(() {
                    widget.departmentId = value;
                  });
                },
                onSaved: (value) {
                  widget.departmentId = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '手机号'),
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  widget.subDepartment = value;
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: '*您目前的所在地：（示例：江苏省南京栖霞区）'),
                validator: (value) {
                  return value.trim().length > 0 ? null : '目前的所在地不能为空';
                },
                onSaved: (value) {
                  widget.addressPresent = value;
                },
              ),
              Container(
                height: 30,
              ),
              Text(
                '今日是否出现发热/乏力/干咳/呼吸困难等症状？',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Radio(
                      value: 0,
                      groupValue: widget.symptomsOne,
                      onChanged: updateSymptomsOne),
                  Text('否'),
                  Radio(
                      value: 1,
                      groupValue: widget.symptomsOne,
                      onChanged: updateSymptomsOne),
                  Text('是'),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Divider(),
              ),
              Text(
                '您的家人是否出现发热/乏力/干咳/呼吸困难等症状？',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Radio(
                      value: 0,
                      groupValue: widget.symptomsOneFamily,
                      onChanged: updateSymptomsOneFamily),
                  Text('否'),
                  Radio(
                      value: 1,
                      groupValue: widget.symptomsOneFamily,
                      onChanged: updateSymptomsOneFamily),
                  Text('是'),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Divider(),
              ),
              Text(
                '您和您的家人今日是否与武汉市或武汉周边的人员有过较为密集的接触？',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Radio(
                      value: 0,
                      groupValue: widget.contactWuhan,
                      onChanged: updateContactWuhan),
                  Text('否'),
                  Radio(
                      value: 1,
                      groupValue: widget.contactWuhan,
                      onChanged: updateContactWuhan),
                  Text('是'),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Divider(height: 1),
              ),
              Text(
                '您所在地（工作/生活场所）是否有任何与疫情相关的，值得注意的情况？',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Radio(
                      value: 0,
                      groupValue: widget.attentionFlag,
                      onChanged: updateAttentionFlag),
                  Text('否'),
                  Radio(
                      value: 1,
                      groupValue: widget.attentionFlag,
                      onChanged: updateAttentionFlag),
                  Text('是'),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '如有上述情况，请仔细描述'),
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  widget.attentionInfo = value == null ? '' : value;
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Divider(height: 1),
              ),
              Text(
                '您上班所选择的交通方式？',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 0,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio<String>(
                          value: '私家车',
                          groupValue: widget.workTraffic,
                          onChanged: updateWorkTraffic),
                      Text('私家车'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio<String>(
                          value: '出租车/网约车',
                          groupValue: widget.workTraffic,
                          onChanged: updateWorkTraffic),
                      Text('出租车/网约车'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio<String>(
                          value: '电瓶车/摩托车/自行车',
                          groupValue: widget.workTraffic,
                          onChanged: updateWorkTraffic),
                      Text('电瓶车/摩托车/自行车'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio<String>(
                          value: '步行',
                          groupValue: widget.workTraffic,
                          onChanged: updateWorkTraffic),
                      Text('步行'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio<String>(
                          value: '公共交通',
                          groupValue: widget.workTraffic,
                          onChanged: updateWorkTraffic),
                      Text('公共交通'),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Divider(height: 1),
              ),
              Text(
                '您的昨日个人活动轨迹？',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 0,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                children: ['上班', '在家', '学校', '医院', '菜场', '超市'].map((value) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                          value: widget.yesterdayTrailSet.contains(value),
                          onChanged: (checked) =>
                              updateYesterdayTrail(value, checked)),
                      Text(value),
                    ],
                  );
                }).toList(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Divider(height: 1),
              ),
              Text(
                '您同住家人的昨日个人活动轨迹？',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 0,
                runSpacing: 4,
                alignment: WrapAlignment.start,
                children: ['上班', '在家', '学校', '医院', '菜场', '超市'].map((value) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                          value: widget.livingFamilyTrailSet.contains(value),
                          onChanged: (checked) =>
                              updateLivingFamilyTrail(value, checked)),
                      Text(value),
                    ],
                  );
                }).toList(),
              ),
              Container(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateSymptomsOne(int value) {
    setState(() {
      widget.symptomsOne = value;
    });
  }

  void updateSymptomsOneFamily(int value) {
    setState(() {
      widget.symptomsOneFamily = value;
    });
  }

  void updateContactWuhan(int value) {
    setState(() {
      widget.contactWuhan = value;
    });
  }

  void updateAttentionFlag(int value) {
    setState(() {
      widget.attentionFlag = value;
    });
  }

  void updateWorkTraffic(String value) {
    setState(() {
      widget.workTraffic = value;
    });
  }

  void updateYesterdayTrail(String value, bool checked) {
    setState(() {
      if (checked) {
        widget.yesterdayTrailSet.add(value);
      } else {
        widget.yesterdayTrailSet.remove(value);
      }
    });
  }

  void updateLivingFamilyTrail(String value, bool checked) {
    setState(() {
      if (checked) {
        widget.livingFamilyTrailSet.add(value);
      } else {
        widget.livingFamilyTrailSet.remove(value);
      }
    });
  }
}

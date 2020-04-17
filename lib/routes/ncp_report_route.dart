import 'dart:convert';
import 'dart:io';
//import 'dart:ffi';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ncpautoreport/network/ncp_report_api.dart';
import 'package:ncpautoreport/network/ncp_report_bean.dart';
import 'package:ncpautoreport/utils/dialog_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NcpReportRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NcpReportRoute();
  }
}

class _NcpReportRoute extends State<NcpReportRoute> {
  GlobalKey<_NcpReportViewState> ncpReportViewKey =
      GlobalKey<_NcpReportViewState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('疫情自动上报'),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Center(
                child: Text('上报信息'),
              ),
            ),
            onTap: () {
              var fromState =
                  ncpReportViewKey.currentState.formKey.currentState;
              if (fromState.validate()) {
                fromState.save();
                ncpReportViewKey.currentState.saveNcpReportBeanToCache();
                NcpReportApi().ncpReport(ncpReportViewKey.currentState.ncpReportBean).then((value) {
                  DialogUtils.showTipDialog(context,
                      value.msg == null || value.msg.length == 0 ? '上报失败' : value.msg);
                }, onError: (e, stack) {
                  print('e=$e,stack=$stack');
                  DialogUtils.showTipDialog(context, 'error:${e.toString()}');
                });
              }
            },
          ),
        ],
      ),
      body: _NcpReportView(key: ncpReportViewKey,),
    );
  }
}

class _NcpReportView extends StatefulWidget {
  _NcpReportView({key: Key}) : super(key : key);

  @override
  State<StatefulWidget> createState() {
    return _NcpReportViewState();
  }
}

class _NcpReportViewState extends State<_NcpReportView> {
  NcpInfoBean ncpInfoBean;
  NcpReportBean ncpReportBean;
  String reportedDate;

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Set<String> yesterdayTrailSet = Set<String>();
  Set<String> livingFamilyTrailSet = Set<String>();

  Future<_NcpFutureBean> future;

  @override
  void initState() {
    super.initState();

    future = getNcpFutureBean();
  }

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilder();
  }

  Widget buildFutureBuilder() {
    return FutureBuilder<_NcpFutureBean>(
      future: future,
      initialData: _NcpFutureBean(null, null),
      builder: (BuildContext context, AsyncSnapshot<_NcpFutureBean> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return buildErrorView();
          } else {
            ncpInfoBean = snapshot.data.ncpInfoBean;
            ncpReportBean = snapshot.data.ncpReportBean;
            ncpReportBean.reportDate =
                formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

            yesterdayTrailSet.clear();
            var tem = ncpReportBean.yesterdayTrail?.split(',')?.toSet();
            if (tem != null) {
              yesterdayTrailSet.addAll(tem);
            }

            livingFamilyTrailSet.clear();
            tem = ncpReportBean.livingFamilyTrail?.split(',')?.toSet();
            if (tem != null) {
              livingFamilyTrailSet.addAll(tem);
            }

            // 下拉列表初始值必须是列表存在的值，所以没有存储之前先指定一个默认值，列表的头一个
            if(ncpReportBean.departmentId == 0) {
              ncpReportBean.departmentId = ncpInfoBean.data[0].departmentId;
            }
            if(ncpReportBean.subDepartment == '') {
              ncpReportBean.subDepartment = null;
            }
            // 交通方式指定一个默认值
            if(ncpReportBean.workTraffic == null || ncpReportBean.workTraffic == '') {
              ncpReportBean.workTraffic = '公共交通';
            }

            return buildNcpReportView(context);
          }
        } else {
          return buildLoadingView();
        }
      },
    );
  }

  Widget buildLoadingView() {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildErrorView() {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            future = getNcpFutureBean();
          });
        },
        child: Center(
          child: Text('网络错误，点击重试...'),
        ),
      ),
    );
  }

  Widget buildNcpReportView(BuildContext context) {
    var getSubDepartmentItems = () {
      var where = ncpInfoBean.data.where((element) {
        return element.departmentId == ncpReportBean.departmentId;
      });
      if(where == null || where.length == 0) {
        return [];
      }
      return where.elementAt(0).subDepartmentNameList.map((value) {
        return DropdownMenuItem<String>(
          child: Text(value),
          value: value,
        );
      }).toList();
    };

    return Padding(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                initialValue: ncpReportBean.reportDate,
              ),
              TextFormField(
                initialValue: ncpReportBean.staffName,
                decoration: InputDecoration(labelText: '*用户名'),
                validator: (value) {
                  return value.trim().length > 0 ? null : '用户名不能为空';
                },
                onSaved: (value) {
                  ncpReportBean.staffName = value;
                },
              ),
              DropdownButtonFormField<int>(
                value: ncpReportBean.departmentId,
                decoration: InputDecoration(labelText: '*选择您的部门'),
                items: ncpInfoBean.data.map((e) {
                  return DropdownMenuItem(
                    child: Text(e.departmentName),
                    value: e.departmentId,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    ncpReportBean.departmentId = value;
                  });
                },
                onSaved: (value) {
                  ncpReportBean.departmentId = value;
                },
              ),
              DropdownButtonFormField<String>(
                value: ncpReportBean.subDepartment,
                decoration: InputDecoration(labelText: '*选择您的子部门'),
                items: getSubDepartmentItems(),
                onChanged: (value) {
                  setState(() {
                    ncpReportBean.subDepartment = value;
                  });
                },
                onSaved: (value) {
                  ncpReportBean.subDepartment = value;
                },
              ),
              TextFormField(
                initialValue: ncpReportBean.mobile,
                decoration: InputDecoration(labelText: '手机号'),
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  ncpReportBean.mobile = value;
                },
              ),
              TextFormField(
                initialValue: ncpReportBean.addressPresent,
                decoration:
                    InputDecoration(labelText: '*您目前的所在地：（示例：江苏省南京栖霞区）'),
                validator: (value) {
                  return value.trim().length > 0 ? null : '目前的所在地不能为空';
                },
                onSaved: (value) {
                  ncpReportBean.addressPresent = value;
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
                      groupValue: ncpReportBean.symptomsOne,
                      onChanged: updateSymptomsOne),
                  Text('否'),
                  Radio(
                      value: 1,
                      groupValue: ncpReportBean.symptomsOne,
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
                      groupValue: ncpReportBean.symptomsOneFamily,
                      onChanged: updateSymptomsOneFamily),
                  Text('否'),
                  Radio(
                      value: 1,
                      groupValue: ncpReportBean.symptomsOneFamily,
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
                      groupValue: ncpReportBean.contactWuhan,
                      onChanged: updateContactWuhan),
                  Text('否'),
                  Radio(
                      value: 1,
                      groupValue: ncpReportBean.contactWuhan,
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
                      groupValue: ncpReportBean.attentionFlag,
                      onChanged: updateAttentionFlag),
                  Text('否'),
                  Radio(
                      value: 1,
                      groupValue: ncpReportBean.attentionFlag,
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
                  ncpReportBean.attentionInfo = value == null ? '' : value;
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
                children: ['私家车', '出租车/网约车', '电瓶车/摩托车/自行车', '步行', '公共交通']
                    .map((value) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio<String>(
                          value: value,
                          groupValue: ncpReportBean.workTraffic,
                          onChanged: updateWorkTraffic),
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
                          value: yesterdayTrailSet.contains(value),
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
                          value: livingFamilyTrailSet.contains(value),
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

  Future<_NcpFutureBean> getNcpFutureBean() {
    return Future.wait(
            [NcpReportApi().getNcpInfo(), getNcpReportBeanFromCache()])
        .then((arrValue) {
      NcpInfoBean ncpInfoBean = arrValue[0];
      NcpReportBean ncpReportBean = arrValue[1];
      print('arrValue=$arrValue');
      if (ncpInfoBean == null || ncpReportBean == null) {
        throw 'bena is null';
      }
      return _NcpFutureBean(ncpInfoBean, ncpReportBean);
    });
  }

  Future<NcpReportBean> getNcpReportBeanFromCache() async {
    NcpReportBean bean;
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var json = sp.getString('ncp_report_json');
      if (json != null) {
        bean = NcpReportBean(json);
      }
    } catch (e) {
      print(e);
    }
    if (bean == null) {
      bean = NcpReportBean.fromParams(
        attentionFlag: 0,
        contactWuhan: 0,
        departmentId: 0,
        symptomsOne: 0,
        symptomsOneFamily: 0,
        addressPresent: '',
        attentionInfo: '',
        livingFamilyTrail: '',
        mobile: '',
        reportDate: '',
        staffName: '',
        subDepartment: '',
        workTraffic: '',
        yesterdayTrail: '',
      );
    }
    print('future bean=${bean.toString()}');
    return bean;
  }

  Future<int> saveNcpReportBeanToCache() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var jsonStr = ncpReportBean == null ? '' : json.encode(ncpReportBean);
      await sp.setString('ncp_report_json', jsonStr);
      print('jsonStr=$jsonStr');
    } catch (e) {
      print(e);
    }
    return null;
  }

  void updateSymptomsOne(int value) {
    setState(() {
      ncpReportBean.symptomsOne = value;
    });
  }

  void updateSymptomsOneFamily(int value) {
    setState(() {
      ncpReportBean.symptomsOneFamily = value;
    });
  }

  void updateContactWuhan(int value) {
    setState(() {
      ncpReportBean.contactWuhan = value;
    });
  }

  void updateAttentionFlag(int value) {
    setState(() {
      ncpReportBean.attentionFlag = value;
    });
  }

  void updateWorkTraffic(String value) {
    setState(() {
      ncpReportBean.workTraffic = value;
    });
  }

  void updateYesterdayTrail(String value, bool checked) {
    setState(() {
      if (checked) {
        yesterdayTrailSet.add(value);
      } else {
        yesterdayTrailSet.remove(value);
      }
    });

    var result = '';
    if (yesterdayTrailSet == null || yesterdayTrailSet.length == 0) {
      ncpReportBean.yesterdayTrail = '';
    } else {
      for (var s in yesterdayTrailSet) {
        if (result == '') {
          result += s;
        } else {
          result += ',' + s;
        }
      }
      ncpReportBean.yesterdayTrail = result;
    }
  }

  void updateLivingFamilyTrail(String value, bool checked) {
    setState(() {
      if (checked) {
        livingFamilyTrailSet.add(value);
      } else {
        livingFamilyTrailSet.remove(value);
      }
    });

    var result = '';
    if (livingFamilyTrailSet == null || livingFamilyTrailSet.length == 0) {
      ncpReportBean.livingFamilyTrail = '';
    } else {
      for (var s in livingFamilyTrailSet) {
        if (result == '') {
          result += s;
        } else {
          result += ',' + s;
        }
      }
      ncpReportBean.livingFamilyTrail = result;
    }
  }
}

class _NcpFutureBean {
  NcpInfoBean ncpInfoBean;
  NcpReportBean ncpReportBean;

  _NcpFutureBean(this.ncpInfoBean, this.ncpReportBean);
}

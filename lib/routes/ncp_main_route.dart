import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ncpautoreport/storage/ncp_storage_entities.dart';

class NcpMainRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NcpState();
  }
}

class _NcpState extends State<NcpMainRoute> {
//  List<NcpPersonEntity> entityList = [NcpPersonEntity.fromParams()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('疫情自动上报'),
      ),
      body: ncpListView(context),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/editNcpItem', arguments: '123');
        },
        tooltip: '添加条目',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget ncpListView(BuildContext context) {
//    return CustomScrollView(
//      slivers: <Widget>[
//        SliverList(
//          delegate: SliverChildBuilderDelegate((context, index) {
//            return _NcpItemView(entityList[index]);
//          }, childCount: entityList.length),
//        ),
//        SliverToBoxAdapter(
//          child: FloatingActionButton(
//            child: Icon(Icons.add),
//            onPressed: () {
//
//            },
//          ),
////          child: Card(
////            child: Padding(
////              padding: EdgeInsets.only(top: 15, bottom: 15),
////              child: Icon(Icons.add),
////            ),
////          ),
////          child: IconButton(
////            icon: Icon(Icons.add),
////            onPressed: () {},
////          ),
//        ),
//      ],
//    );
    return ListView.separated(
        itemBuilder: (context, index) {
          return null/*_NcpItemView(entityList[index])*/;
        },
        separatorBuilder: (context, index) => Divider(height: 0),
        itemCount: /*entityList.length*/0);
  }
}

class _NcpItemView extends StatelessWidget {
//  NcpPersonEntity entity;

//  _NcpItemView(this.entity);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            print('card click');
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        '李冠良',
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '部门：',
                            style: TextStyle(fontSize: 15),
                          ),
                          Expanded(
                            child: Text(
                              '创新部' /*entity.subDepartment*/,
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '所在地：',
                            style: TextStyle(fontSize: 15),
                          ),
                          Expanded(
                            child: Text(
                              '北京石景山' /*entity.subDepartment*/,
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '交通方式：',
                            style: TextStyle(fontSize: 15),
                          ),
                          Expanded(
                            child: Text(
                              '公共交通' /*entity.subDepartment*/,
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      RaisedButton(
                        child: Text('上报'),
                        onPressed: () {
                          print('raise button click');
                        },
                      ),
                    ],
                  ),
                ),
                Icon(Icons.edit),
              ],
            ),
          )),
    );
  }
}

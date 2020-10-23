import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body:ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Developers',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  const url = 'https://github.com/ashu12chi';
                  if (await canLaunch(url)) {
                  await launch(url);
                  }
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8),
                        child: Image.asset('assets/ashutosh.jpeg',width: 150,height: 150,),
                      ),
                      Text('Ashutosh Chitranshi\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 16),)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  const url = 'https://github.com/nisiddharth';
                  if (await canLaunch(url)) {
                  await launch(url);
                  }
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8),
                        child: Image.asset('assets/nishchal.jpeg',width: 150,height: 150,),
                      ),
                      Text('Nishchal Siddharth\nPandey',textAlign: TextAlign.center,style: TextStyle(fontSize: 16),)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  const url = 'https://github.com/Anushkaa-Srivastava';
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8),
                        child: Image.asset('assets/anushka.jpeg',width: 150,height: 150,),
                      ),
                      Text('Anushka Srivastava',textAlign: TextAlign.center,style: TextStyle(fontSize: 16),)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Container(
              height: 1.0,
              width: double.infinity,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Process Flow',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('1. User can register on the app and choose his topics of interest (these can be modified later).',style: TextStyle(fontSize: 16,color: Colors.grey),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('2. Users can post articles which may contain image, text, gif, video, audio embedded.',style: TextStyle(fontSize: 16,color: Colors.grey),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('3. Users can upvote/ downvote and comment on any article.',style: TextStyle(fontSize: 16,color: Colors.grey),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('4. User can edit or delete only his/her post but admins can do it for all the posts.',style: TextStyle(fontSize: 16,color: Colors.grey),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('5. Views will be counted for every article. Users can stream live video in a community and members of that community can join in to watch the stream.',style: TextStyle(fontSize: 16,color: Colors.grey),),
          ),
        ],
      )
    );
  }
}

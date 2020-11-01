import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// @author: Ashutosh Chitranshi
// Oct 20, 2020
// This is just about section of app ;)

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Developers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    const url = 'https://ashu12chi.github.io/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: CachedNetworkImage(
                            width: 150,
                            height: 150,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/appAssets%2Fashutosh.jpeg?alt=media&token=84eb7f51-4141-434a-a294-569d95678198',
                          ),
                        ),
                        Text(
                          'Ashutosh Chitranshi\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    const url = 'https://nisiddharth.github.io/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: CachedNetworkImage(
                            width: 150,
                            height: 150,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/appAssets%2Fnishchal.jpeg?alt=media&token=96570a13-857d-4516-bc4f-f40a0f2aae3e',
                          ),
                        ),
                        Text(
                          'Nishchal Siddharth\nPandey',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        )
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
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: CachedNetworkImage(
                            width: 150,
                            height: 150,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/brighterbee-npdevs.appspot.com/o/appAssets%2Fanushka.jpeg?alt=media&token=e46ccb39-452d-4048-8650-de173372399b',
                          ),
                        ),
                        Text(
                          'Anushka Srivastava',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        )
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
              child: Text(
                'Process Flow',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '1. User can register on the app and choose his topics of interest (these can be modified later).',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '2. Users can post articles which may contain image, text, gif, video, audio embedded.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '3. Users can upvote/ downvote and comment on any article.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '4. User can edit or delete only his/her post but admins can do it for all the posts.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '5. Views will be counted for every article. Users can stream live video in a community and members of that community can join in to watch the stream.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ));
  }
}

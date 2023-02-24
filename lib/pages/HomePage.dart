// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lipa_music/login_screen.dart';
import '../widgets/MusicList.dart';
import '../widgets/PlayList.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> imagesUrl = [];

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  void playOrPause() async {
    await assetsAudioPlayer.playOrPause();
  }

  List<String> songsUrl = [];
  bool loading = false;

  void onStart() async {
    final storageRef = FirebaseStorage.instance.ref();
    setState(() {
      loading = !loading;
    });
    for (int i = 1; i <= 4; i++) {
      final httpsReference1 =
          await storageRef.child('images/song$i.jpg').getDownloadURL();
      final httpsReference2 =
          await storageRef.child('songs/song$i.mp3').getDownloadURL();
      imagesUrl.add(httpsReference1);
      songsUrl.add(httpsReference2);
    }
    setState(() {
      loading = !loading;
    });
  }

  @override
  void initState() {
    onStart();
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF303151).withOpacity(0.6),
              Color(0xFF303151).withOpacity(0.9),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 22),
              child: loading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.sort_rounded,
                                  color: Color(0xFF899CCF),
                                  size: 30,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  "Lipa music",
                                  style: TextStyle(
                                    color: Color(0xFF899CCF),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  // await FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.exit_to_app,
                                  color: Color(0xFF899CCF),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            "Hello Olzhas",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            "What are we going to listen to today?",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 15, right: 20, bottom: 20),
                          child: Container(
                            height: 50,
                            width: 380,
                            decoration: BoxDecoration(
                              color: Color(0xFF31314F),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  height: 50,
                                  width: 200,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Search the music",
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TabBar(
                          isScrollable: true,
                          labelStyle: TextStyle(fontSize: 18),
                          indicator: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 3, color: Color(0xFF899CCF)),
                            ),
                          ),
                          tabs: [
                            Tab(
                              text: "Musics",
                            ),
                            Tab(
                              text: "Playlists",
                            ),
                            Tab(
                              text: "Favourites",
                            ),
                            Tab(
                              text: "Trending",
                            ),
                            Tab(
                              text: "Collections",
                            ),
                            Tab(
                              text: "New",
                            ),
                          ],
                        ),
                        Flexible(
                          flex: 1,
                          child: TabBarView(
                            children: [
                              MusicList(
                                notifyParent: refresh,
                                urls: songsUrl,
                                assetsAudioPlayer: assetsAudioPlayer,
                              ),
                              PlayList(),
                              MusicList(
                                notifyParent: refresh,
                                urls: songsUrl,
                                assetsAudioPlayer: assetsAudioPlayer,
                              ),
                              MusicList(
                                notifyParent: refresh,
                                urls: songsUrl,
                                assetsAudioPlayer: assetsAudioPlayer,
                              ),
                              MusicList(
                                notifyParent: refresh,
                                urls: songsUrl,
                                assetsAudioPlayer: assetsAudioPlayer,
                              ),
                              MusicList(
                                notifyParent: refresh,
                                urls: songsUrl,
                                assetsAudioPlayer: assetsAudioPlayer,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

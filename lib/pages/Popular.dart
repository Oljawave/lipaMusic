// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: library_private_types_in_public_api

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lipa_music/login_screen.dart';
import 'package:lipa_music/pages/MusicPlayer.dart';
import 'package:lipa_music/pages/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: const Icon(Icons.search),
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Hello, Pathway",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "India",
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 15),
            child: InkWell(
              onTap: () async {
                // await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.exit_to_app,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ...[
            loading == true
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "most",
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "popular",
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 20),
                          child: Text(
                            "960 playlists",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        Container(
                          height: 300,
                          child: TrackWidget(refresh),
                        ),
                        CircleTrackWidget(
                          song: mostPopular,
                          title: "your playlist",
                          subtitle: "346 songs",
                          notifyParent: refresh,
                          urls: songsUrl,
                          assetsAudioPlayer: assetsAudioPlayer,
                        ),
                        const SizedBox(
                          height: 130,
                        )
                      ],
                    ),
                  ),
          ],
          Align(
            alignment: Alignment.bottomCenter,
            child: PlayerHome(
              song: currentSong,
              assetsAudioPlayer: assetsAudioPlayer,
            ),
          )
        ],
      ),
    );
  }

  refresh() {
    setState(() {});
  }
}

Song currentSong = Song(
    name: "title",
    singer: "singer",
    image: "images/song1.jpg",
    duration: 100,
    color: Colors.black);
double currentSlider = 0;

class PlayerHome extends StatefulWidget {
  final Song song;
  final AssetsAudioPlayer assetsAudioPlayer;
  PlayerHome({required this.song, required this.assetsAudioPlayer});

  @override
  _PlayerHomeState createState() => _PlayerHomeState();
}

class _PlayerHomeState extends State<PlayerHome> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => MusicPlayer(
              song: widget.song,
              assetsAudioPlayer: widget.assetsAudioPlayer,
            ),
          ),
        );
      },
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: "image",
                      child: CircleAvatar(
                        backgroundImage: AssetImage(widget.song.image),
                        radius: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.song.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(widget.song.singer,
                            style: const TextStyle(
                              color: Colors.white54,
                            ))
                      ],
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Icon(Icons.pause, color: Colors.white, size: 30),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.skip_next_outlined,
                        color: Colors.white, size: 30),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Duration(seconds: currentSlider.toInt())
                      .toString()
                      .split('.')[0]
                      .substring(2),
                  style: const TextStyle(color: Colors.white),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 4),
                      trackShape: const RectangularSliderTrackShape(),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: currentSlider,
                      max: widget.song.duration.toDouble(),
                      min: 0,
                      inactiveColor: Colors.grey[500],
                      activeColor: Colors.white,
                      onChanged: (val) {
                        setState(() {
                          currentSlider = val;
                        });
                      },
                    ),
                  ),
                ),
                Text(
                  Duration(seconds: widget.song.duration)
                      .toString()
                      .split('.')[0]
                      .substring(2),
                  style: const TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TrackWidget extends StatelessWidget {
  final Function() notifyParent;
  const TrackWidget(this.notifyParent, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mostPopular.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            currentSong = mostPopular[index];
            currentSlider = 0;
            notifyParent();
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: mostPopular[index].color,
                  blurRadius: 1,
                  spreadRadius: 0.3,
                )
              ],
              image: DecorationImage(
                image: AssetImage(mostPopular[index].image),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mostPopular[index].name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    mostPopular[index].singer,
                    style: const TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CircleTrackWidget extends StatefulWidget {
  final String title;
  final List<Song> song;
  final List<String> urls;
  final String subtitle;
  final Function() notifyParent;
  final AssetsAudioPlayer assetsAudioPlayer;

  CircleTrackWidget({
    required this.title,
    required this.song,
    required this.subtitle,
    required this.urls,
    required this.notifyParent,
    required this.assetsAudioPlayer,
  });

  @override
  State<CircleTrackWidget> createState() => _CircleTrackWidgetState();
}

class _CircleTrackWidgetState extends State<CircleTrackWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              widget.subtitle,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Container(
            height: 120,
            child: ListView.builder(
              itemCount: widget.song.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    currentSong = widget.song[index];
                    currentSlider = 0;
                    widget.notifyParent();
                    try {
                      await widget.assetsAudioPlayer.stop();
                      await widget.assetsAudioPlayer.open(
                        Audio.network(widget.urls[index]),
                      );
                    } catch (t) {
                      //mp3 unreachable
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(widget.song[index].image),
                          radius: 40,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.song[index].name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.song[index].singer,
                          style: const TextStyle(color: Colors.white54),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

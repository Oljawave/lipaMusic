import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../pages/MusicPlayer.dart';
import '../pages/database.dart';

class MusicList extends StatefulWidget {
  final AssetsAudioPlayer assetsAudioPlayer;
  final List<String> urls;
  final Function() notifyParent;
  MusicList({
    required this.assetsAudioPlayer,
    required this.urls,
    required this.notifyParent,
  });

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mostPopular.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top: 15, right: 12, left: 5),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFF30314D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 25),
                      InkWell(
                        onTap: () async {
                          Song currentSong = mostPopular[index];
                          currentSlider = 0;
                          widget.notifyParent();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Color(0xFF303151).withOpacity(0.6),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            ),
                          );
                          try {
                            await widget.assetsAudioPlayer.stop();
                            await widget.assetsAudioPlayer.open(
                              Audio.network(widget.urls[index]),
                            );
                          } catch (t) {
                            //mp3 unreachable
                          }
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          await Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, _, __) => MusicPlayer(
                                song: mostPopular[index],
                                assetsAudioPlayer: widget.assetsAudioPlayer,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mostPopular[index].name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  mostPopular[index].singer,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "-",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "3:35",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.play_arrow,
                            size: 25,
                            color: Color(0xFF31314F),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

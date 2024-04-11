import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicplayer/constant/color.dart';
import 'package:musicplayer/constant/strings.dart';
import 'package:musicplayer/model/music.dart';
import 'package:musicplayer/view/widgets/artwork.dart';
import 'package:musicplayer/view/widgets/lyricpage.dart';
import 'package:spotify/spotify.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:palette_generator/palette_generator.dart';


class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {

  Music music = Music(trackId:"2WO5nzB7QtKn9ZRc9Jkalt?si=7f39965063d9417c" );
  // Color songcolor = Color(0xFF251117);
  // String artistName = "";
  // String songName = "";
  // // String musicTrackId = "4cktbXiXOapiLBMprHFErI?si=f3593bbe15e243d6";
  // String? songImage ;
  // Color songColor = Color(0xFF251117);
  // String? artistImage;
  // Duration? duration;
  final player = AudioPlayer();
  @override
 void initState() {
    // TODO: implement initState
    final credentials = SpotifyApiCredentials(
      CustomStrings.customId, CustomStrings.customSecret);
      final spotify = SpotifyApi(credentials);
      spotify.tracks.get(music.trackId).then((track) async {
  String? tempsSongName =track.name;
  if(tempsSongName != null)
  {
    music.songName = tempsSongName;
    music.artistName = track.artists?.first.name ?? "";
        String? image = track.album?.images?.first.url;
        if(image != null)
        {
          music.songImage = image;
          final tempSongColor = await getImagePallete(NetworkImage(image));
          if (tempSongColor != null) {
            music.songcolor = tempSongColor;
          }
        }

        music.artistImage = track.artists?.first.images?.first.url ?? "";
     final yt = YoutubeExplode();
     final video = (await yt.search.search(tempsSongName)).first;
     final videoId = video.id.value;
     music.duration = video.duration;
     setState(() {});
     var manifest = await yt.videos.streamsClient.getManifest(videoId);
     var audioUrl = manifest.audioOnly.first.url;
     player.play(UrlSource(audioUrl.toString()));
  }
 

});

    super.initState();
  }
  Future <Color?> getImagePallete (ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator
    .fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color;
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: music.songcolor ,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: Column(children: [
            SizedBox(
              height: 16,
            ),
             SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Icon(Icons.close, color: Colors.transparent,),
                Column(mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Singing Now",style: textTheme.bodyMedium?.copyWith(color: CustomColors.primaryColor),),
                    
                    Row(
                     children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage:music.artistImage != null?NetworkImage(music.artistImage!):null,
                        radius: 10,
                      ),
                      SizedBox(width: 2,),
                      Text(music.artistName ?? '-',style: textTheme.bodyLarge?.copyWith(color: Colors.white),)
                     ],
                    )
                  ],
                ),
                 Icon(Icons.close,color: Colors.white,),
               ],
            ),
          Expanded(
            flex: 2,
            child: 
            Center(
              child: ArtWorkImage(image: music.songImage != null?music.songImage!:"https://i.ytimg.com/vi/6PmFCzYt9fJlh1MlKLcpFs/maxresdefault.jpg"),
              
              )),
             Expanded(child: Column(
               children: [
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(music.songName ?? '',style: textTheme.titleLarge?.copyWith(color: Colors.white),),
                          // Text("Freindship with forever",style: textTheme.titleMedium?.copyWith(color: Colors.white60),)
                        ],
                      ),
                    ),
                    Icon(Icons.favorite ,color: CustomColors.primaryColor,)
                  ],
                 ),
                 SizedBox(height: 16,),
                StreamBuilder(
                      stream: player.onPositionChanged,
                      builder: (context, data) {
                        return ProgressBar(
                          progress: data.data ?? const Duration(seconds: 0),
                          total: music.duration ?? const Duration(minutes: 4),
                          bufferedBarColor: Colors.white38,
                          baseBarColor: Colors.white10,
                          thumbColor: Colors.white,
                          timeLabelTextStyle:
                              const TextStyle(color: Colors.white),
                          progressBarColor: Colors.white,
                          onSeek: (duration) {
                            player.seek(duration);
                          },
                        );
                      }),
               SizedBox(height: 16,),

               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => LyricsPage(music: music,player: player,))));
                    }, 
                    icon: Icon(Icons.lyrics,color:Colors.white)),
                  IconButton(
                    onPressed: (){},
                     icon: Icon(Icons.skip_previous,color: Colors.white,size: 36,)),
                  IconButton(
                    onPressed: () async{
                      if(player.state == PlayerState.playing){
                        await player.pause();
                      }else{
                        await player.resume();}
                        setState(() {});
                    }, 
                    
                    icon: Icon(
                      player.state == PlayerState.playing?Icons.pause_circle:Icons.play_circle,color: Colors.white,size: 60,)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.skip_next,color: Colors.white,size: 36,)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.loop,color: CustomColors.primaryColor))
                ],
               )
               ],
             ))
          ]),
        ),
      ),
     
    );
  }
}


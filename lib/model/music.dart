import 'package:flutter/material.dart';

class Music{
 
String trackId;
 String?  artistName;
 String? songName;
 String? songImage; 
 String? artistImage;
 Duration? duration;
 Color? songcolor; 

  Music( {
        required this.trackId, 
        this.artistName,
        this.songName, 
        this.songImage, 
        this.artistImage,  
        this.duration,
        this.songcolor,});
 
}
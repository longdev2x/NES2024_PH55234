import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nes24_ph55234/data/models/music_entity.dart';
import 'package:nes24_ph55234/data/repositories/music_repos.dart';

class MusicPlayerState {
  final List<MusicEntity> playlist;
  final MusicEntity? currentSong;
  final PlayerState playerState;

  MusicPlayerState({
    required this.playlist,
    this.currentSong,
    required this.playerState,
  });
}

class MusicPlayerNotifier extends AutoDisposeAsyncNotifier<MusicPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  FutureOr<MusicPlayerState> build() {
    return _init();
  }

  Future<MusicPlayerState> _init() async {
    final playlist = await MusicRepos.getMusicList();

    return MusicPlayerState(
      playlist: playlist,
      playerState: PlayerState(false, ProcessingState.idle),
    );
  }

  Future<void> play(MusicEntity song) async {
    if (state.value!.currentSong?.id != song.id) {
      await _audioPlayer.stop();
    }

    try {
      state = AsyncValue.data(MusicPlayerState(
        playlist: state.value!.playlist,
        currentSong: song,
        playerState: PlayerState(true, ProcessingState.ready),
      ));

      await _audioPlayer.setUrl(song.url);
      await _audioPlayer.play();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> pause() async {
    state = AsyncValue.data(MusicPlayerState(
      playlist: state.value!.playlist,
      currentSong: state.value!.currentSong,
      playerState: PlayerState(false, ProcessingState.ready),
    ));

    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    state = AsyncValue.data(MusicPlayerState(
      playlist: state.value!.playlist,
      currentSong: state.value!.currentSong,
      playerState: PlayerState(true, ProcessingState.ready),
    ));
    
    await _audioPlayer.play();
  }
}

final musicPlayerProvider =
    AutoDisposeAsyncNotifierProvider<MusicPlayerNotifier, MusicPlayerState>(
        () => MusicPlayerNotifier());

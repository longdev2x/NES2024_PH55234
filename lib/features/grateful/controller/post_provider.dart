import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';

final limitProvider = StateProvider<PostLimit>((ref) => PostLimit.private);
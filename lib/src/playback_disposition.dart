/*
 * This file is part of Flutter-Sound.
 *
 *   Flutter-Sound is free software: you can redistribute it and/or modify
 *   it under the terms of the Lesser GNU General Public License
 *   version 3 (LGPL3) as published by the Free Software Foundation.
 *
 *   Flutter-Sound is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the Lesser GNU General Public License
 *   along with Flutter-Sound.  If not, see <https://www.gnu.org/licenses/>.
 */

/// Used to stream data about the position of the
/// playback as playback proceeds.
class PlaybackDisposition {
  /// The duration of the media.
  Duration duration;

  /// The current position within the media
  /// that we are playing.
  Duration position;

  /// A convenience ctor. If you are using a stream builder
  /// you can use this to set initialData with both duration
  /// and postion as 0.
  PlaybackDisposition.zero()
      : duration = Duration(seconds: 0),
        position = Duration(seconds: 0);

  /// Contrucsts a PlaybackDisposition from a json object.
  /// This is used internally to deserialise data coming
  /// up from the underlying OS.
  PlaybackDisposition.fromJSON(Map<String, dynamic> json)
      : duration = Duration(
            milliseconds: double.parse(json['duration'] as String).toInt()),
        position = Duration(
            milliseconds:
                double.parse(json['current_position'] as String).toInt()) {
    /// looks like the android subsystem can generate -ve values
    /// during some transitions so we protect ourselves.
    if (duration.inMilliseconds < 0) duration = Duration.zero;
    if (position.inMilliseconds < 0) position = Duration.zero;

    /// when playing an mp3 I've seen occurances where the position is after
    /// the duration. So I've added this protection.
    if (position > duration) {
      print('Fixed position > duration $position $duration');
      duration = position;
    }
  }

  @override
  String toString() {
    return 'duration: $duration, '
        'position: $position';
  }
}
// ============================================================
//  ads.dart — Ad Model
// ============================================================

class Ad {
  final String id;
  final String tagline;
  final String caption;
  final String backgroundAsset; // asset path e.g. 'assets/logo/A24.png'
  final String buttonLabel;
  final String? actionUrl;      // deep-link / route to push on "Explore"

  const Ad({
    required this.id,
    required this.tagline,
    required this.caption,
    required this.backgroundAsset,
    this.buttonLabel = 'Explore Now',
    this.actionUrl,
  });

  Ad copyWith({
    String? id,
    String? tagline,
    String? caption,
    String? backgroundAsset,
    String? buttonLabel,
    String? actionUrl,
  }) {
    return Ad(
      id:              id              ?? this.id,
      tagline:         tagline         ?? this.tagline,
      caption:         caption         ?? this.caption,
      backgroundAsset: backgroundAsset ?? this.backgroundAsset,
      buttonLabel:     buttonLabel     ?? this.buttonLabel,
      actionUrl:       actionUrl       ?? this.actionUrl,
    );
  }

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id:              json['id']              as String,
      tagline:         json['tagline']         as String,
      caption:         json['caption']         as String,
      backgroundAsset: json['backgroundAsset'] as String,
      buttonLabel:     (json['buttonLabel']    as String?) ?? 'Explore Now',
      actionUrl:       json['actionUrl']       as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':              id,
    'tagline':         tagline,
    'caption':         caption,
    'backgroundAsset': backgroundAsset,
    'buttonLabel':     buttonLabel,
    'actionUrl':       actionUrl,
  };
}

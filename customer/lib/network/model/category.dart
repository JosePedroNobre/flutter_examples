import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:json_annotation/json_annotation.dart';

enum Category {
  @JsonValue("featured")
  FEATURED,
  @JsonValue("breakfast")
  BREAKFAST,
  @JsonValue("lunch")
  LUNCH,
  @JsonValue("dinner")
  DINNER,
}

extension CategoryInfo on Category {
  String name() {
    switch (this) {
      case Category.FEATURED:
        return "Featured";
      case Category.BREAKFAST:
        return "Breakfast";
      case Category.LUNCH:
        return "Lunch";
      case Category.DINNER:
        return "Dinner";
      default:
        return "Unknown";
    }
  }

  String icon() {
    switch (this) {
      case Category.FEATURED:
        return "🍱";
      case Category.BREAKFAST:
        return "🥐";
      case Category.LUNCH:
        return "🍔";
      case Category.DINNER:
        return "🍣";
      default:
        return null;
    }
  }
}

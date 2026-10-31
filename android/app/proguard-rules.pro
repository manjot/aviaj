# Google AdMob & Unity Ads Production ProGuard Rules
-keep class com.google.android.gms.ads.** { *; }
-keep class com.unity3d.ads.** { *; }
-keep class com.unity3d.services.** { *; }
-dontwarn com.google.errorprone.annotations.**

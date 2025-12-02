# Flutter framework
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Main app classes
-keep class com.app.hello_restaurant.** { *; }

# Firebase Messaging
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Retain R classes and BuildConfig
-keep class **.R$* { *; }
-keep class **.BuildConfig { *; }

# Strip Log statements
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# ════════════════════════════════════════════════════════════════════════
#  ProGuard / R8 Rules for Gate Flutter App
# ════════════════════════════════════════════════════════════════════════

# ── Flutter ──────────────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**

# ── Firebase Core ────────────────────────────────────────────────────────
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Firebase uses reflection to instantiate internal components
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# ── Firebase Auth ────────────────────────────────────────────────────────
-keep class com.google.firebase.auth.** { *; }
-keep class com.google.firebase.auth.internal.** { *; }

# ── Cloud Firestore ──────────────────────────────────────────────────────
-keep class com.google.firebase.firestore.** { *; }
-keep class com.google.firestore.** { *; }

# ── Google Sign-In ───────────────────────────────────────────────────────
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class io.flutter.plugins.googlesignin.** { *; }

# ── OkHttp / Okio (used by Dio) ──────────────────────────────────────────
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# ── Kotlin ───────────────────────────────────────────────────────────────
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
# Keep coroutines
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

# ── Protobuf (used by Firestore) ──────────────────────────────────────────
-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**

# ── App Entry Point ───────────────────────────────────────────────────────
-keep class com.medelyes970.gate.** { *; }

# ── General Android ──────────────────────────────────────────────────────
# Keep Parcelable implementations intact
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
# Keep R class fields referenced by name
-keepclassmembers class **.R$* {
    public static <fields>;
}
